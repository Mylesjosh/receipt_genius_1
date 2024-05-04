import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:image/image.dart' as img;

import 'receipt_database.dart';

class ReceiptPage extends StatefulWidget {
  final Function(Map<String, List<String>>) onSaveReceipt;
  ReceiptPage({required this.onSaveReceipt});

  @override
  _ReceiptPageState createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  List<TextEditingController> itemControllers = [];
  List<TextEditingController> priceControllers = [];
  TextEditingController receiptemailController = TextEditingController();
  int fieldCount = 0; // Start with two sets of text fields
  final List<String> savedReceipts = []; // To store saved PDF paths
  final GlobalKey<SignatureState> _businessOwnerSignKey = GlobalKey();
  final GlobalKey<SignatureState> _customerSignKey = GlobalKey();

  Future<void> _generateAndSaveReceipt() async {
    try {
      // Show progress indicator while logging in
      showDialog(
        context: context,
        barrierDismissible: true, // Prevent dialog from being dismissed
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      if (itemControllers.isNotEmpty && priceControllers.isNotEmpty) {
        final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('businessOwners').doc(FirebaseAuth.instance.currentUser!.uid).get();

        // Safely check if the document exists and contains the 'logoUrl' field
        if(userDoc.exists) {
          final data = userDoc.data() as Map<String, dynamic>?;
          if (data != null && data.containsKey('logoUrl')) {
            final String? logoUrl = data['logoUrl'];

            Uint8List? logoBytes;
            if (logoUrl != null) {
              final response = await http.get(Uri.parse(logoUrl));
              if (response.statusCode == 200) {
                logoBytes = response.bodyBytes;
              }
            }

            if (logoBytes == null) {
              logoBytes =
                  (await rootBundle.load('lib/images/logorec1.png')).buffer
                      .asUint8List();
            }

            final img.Image logoImage = img.decodeImage(logoBytes)!;

            final ui.Image? businessOwnerImage = await _businessOwnerSignKey
                .currentState!.getData();
            final ui.Image? customerImage = await _customerSignKey.currentState!
                .getData();

            if (businessOwnerImage == null || customerImage == null) {
              print("One or both images are null.");
              return;
            }

            final ByteData? businessOwnerData = await businessOwnerImage
                .toByteData(format: ui.ImageByteFormat.png);
            final ByteData? customerData = await customerImage.toByteData(
                format: ui.ImageByteFormat.png);

            final Uint8List businessOwnerBytes = businessOwnerData?.buffer
                .asUint8List() ?? Uint8List(0);
            final Uint8List customerBytes = customerData?.buffer
                .asUint8List() ?? Uint8List(0);

            final img.Image businessOwnerImg = img.decodeImage(
                businessOwnerBytes)!;
            final img.Image customerImg = img.decodeImage(customerBytes)!;
            final pdf = pw.Document();

            pdf.addPage(
              pw.Page(
                pageFormat: PdfPageFormat.a5,
                build: (pw.Context context) {
                  return pw.Column(
                    children: [
                      pw.Center(child: pw.Text(
                          "Receipt", style: pw.TextStyle(fontSize: 24))),
                      pw.SizedBox(height: 5),
                      pw.Center(child: pw.Image(
                          pw.MemoryImage(logoBytes!), width: 100,
                          height: 100),),
                      pw.SizedBox(height: 10),
                      pw.Center(child: pw.Text("------------------------------")),
                      pw.SizedBox(height: 10),
                      for (int i = 0; i < fieldCount &&
                          i < itemControllers.length &&
                          i < priceControllers.length; i++)
                        pw.Column(
                          children: [
                            _buildItemRow(itemControllers[i].text,
                                priceControllers[i].text),
                            pw.SizedBox(height: 10),
                          ],
                        ),
                      pw.SizedBox(height: 20),
                      _buildTotal(),
                      pw.SizedBox(height: 10),
                      pw.Center(child: pw.Text("------------------------------")),
                      pw.SizedBox(height: 10),
                      pw.Center(child: pw.Text("Business Owner Signature",
                          style: pw.TextStyle(fontSize: 18))),
                      pw.Image(pw.MemoryImage(businessOwnerBytes), width: 200,
                          height: 100),
                      pw.SizedBox(height: 20),
                      pw.Center(child: pw.Text("Customer's Signature",
                          style: pw.TextStyle(fontSize: 18))),
                      pw.Image(pw.MemoryImage(customerBytes), width: 200,
                          height: 100),
                    ],
                  );
                },
              ),
            );

            final appDocDir = await getApplicationDocumentsDirectory();
            final pdfPath = appDocDir.path + '/receipt_${DateTime
                .now()
                .millisecondsSinceEpoch}.pdf';
            final file = File(pdfPath);
            final pdfBytes = await pdf.save();
            await file.writeAsBytes(pdfBytes);

            final storage = FirebaseStorage.instance;
            final ref = storage.ref().child(
                'receipts/${FirebaseAuth.instance.currentUser!.uid}/${DateTime
                    .now()
                    .millisecondsSinceEpoch}.pdf');
            await ref.putData(pdfBytes);

            final downloadUrl = await ref.getDownloadURL();

            final firestore = FirebaseFirestore.instance;
            /*await firestore.collection('receipts').add({
              'userId': FirebaseAuth.instance.currentUser!.uid,
              'creationDate': DateTime.now(),
              'downloadUrl': downloadUrl,
            });*/
            // Add the receipt's details to Firestore
            addDataToFirestore('receipts', {
              'userId': FirebaseAuth.instance.currentUser!.uid,
              'creationDate': DateTime.now(),
              'downloadUrl': downloadUrl,
            });
            Navigator.of(context).pop();
            print("Receipt saved as $pdfPath");

            sendReceiptEmail(pdfPath);

            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Receipt Preview"),
                  content: Container(
                    height: 300,
                    child: SfPdfViewer.file(file),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Close"),
                    ),
                  ],
                );
              },
            );
          } else {
            print(
                "Document does not exist or does not contain 'logoUrl' field.");
            // Handle the case where the document does not exist or the field is missing
          }
        }
      }
    } catch (e, stackTrace) {
      print("Error generating and saving receipt: $e");
      print("Stack trace: $stackTrace");
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("An error occurred while generating and saving the receipt."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  void addDataToFirestore(String collectionName, Map<String, dynamic> data) {
    FirebaseFirestore.instance.collection(collectionName).add(data).then((_) {
      print("Data added to collection $collectionName");
    }).catchError((error) {
      print("Failed to add data to collection $collectionName: $error");
    });
  }

  Future<void> sendReceiptEmail(String receiptPath) async {
    final Email email = Email(
      body: 'Here is your receipt.',
      subject: ' Receipt Genius ',
      recipients: [receiptemailController.text.toString()], // Replace with the customer's email
      attachmentPaths: [receiptPath],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (e) {
      if ((e as PlatformException).code == 'not_available') {
        print('No email clients found. Please install an email client.');
        // Optionally, show a dialog or a message to the user
      }
    }

  }


  Future<void> loadReceipts() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final QuerySnapshot querySnapshot = await firestore.collection('receipts').where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();

      setState(() {
        savedReceipts.clear(); // Clear the list before adding new receipts
        for (var doc in querySnapshot.docs) {
          savedReceipts.add(doc.id); // Store the entire document snapshot
        }
      });
    } catch (e) {
      print("Error loading receipts: $e");
    }
  }


  pw.Row _buildItemRow(String itemName, String price) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(itemName, style: pw.TextStyle(fontSize: 16)),
        pw.Text(price, style: pw.TextStyle(fontSize: 16)),
      ],
    );
  }

  pw.Row _buildTotal() {
    double total = 0.0;
    for (int i = 0; i < fieldCount && i < priceControllers.length; i++) {
      double price = double.tryParse(priceControllers[i].text) ?? 0.0;
      total += price;
    }
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text("Total:", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.Text(total.toStringAsFixed(2), style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
      ],
    );
  }

  void _addItemField() {
    setState(() {
      itemControllers.add(TextEditingController());
      priceControllers.add(TextEditingController());
      fieldCount++;
    });
  }

  void _removeItemField() {
    setState(() {
      itemControllers.remove(TextEditingController());
      priceControllers.remove(TextEditingController());
      fieldCount--;
    });
  }

  Map<String, List<String>> savedReceiptsUrlsByDate = {};

  @override
  void initState() {
    super.initState();
    widget.onSaveReceipt(savedReceiptsUrlsByDate); // Call the onSaveReceipt
    _addItemField();
    loadReceipts();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Receipt Generator")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [Column(
            children: [
              TextField(
                controller: receiptemailController,
                decoration: InputDecoration(labelText: "Receipt's Owner Email"),
              ),
              for (int i = 0; i < fieldCount; i++)
                Column(
                  children: [
                    TextField(
                      controller: itemControllers[i],
                      decoration: InputDecoration(labelText: "Item ${i + 1}"),
                    ),
                    TextField(
                      controller: priceControllers[i],
                      decoration: InputDecoration(labelText: "Price ${i + 1}"),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              Row(crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(onPressed: _addItemField, icon: Icon(Icons.add_circle)),
                  SizedBox(width: 5.h,),
                  IconButton(onPressed: _removeItemField, icon: Icon(Icons.remove_circle)),
                ],
              ),

              SizedBox(height: 20),
              Text("Business"),
              Container(
                color: Colors.white,
                height: 60.h,
                child: Signature(
                  key: _businessOwnerSignKey,
                  color: Colors.black,
                  strokeWidth: 2.0,
                ),
              ),
              SizedBox(height: 20),
              Text("Customer"),
              Container(
                color: Colors.white,
                height: 60.h,
                child: Signature(
                  key: _customerSignKey,
                  color: Colors.black,
                  strokeWidth: 2.0,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _generateAndSaveReceipt,
                child: Text("Generate Receipt"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final currentUser = FirebaseAuth.instance.currentUser;
                    final userId = currentUser?.uid;

                    final firestore = FirebaseFirestore.instance;
                    //final querySnapshot = await firestore.collection('receipts').get();

                      final querySnapshot = await firestore.collection('receipts')
                          .where('userId', isEqualTo: userId)
                          .get();


                    for (var doc in querySnapshot.docs) {
                      print("Document ID: ${doc.id}"); // Print the document ID
                      print(doc.data()); // Print the entire document data
                      String? creationDate = doc.get('creationDate')
                          .toDate()
                          .toString();
                      String? downloadUrl = doc.get('downloadUrl') as String?;
                      print("Download URL: $downloadUrl"); // Debugging line
                      if (creationDate != null && downloadUrl != null) {
                        if (!savedReceiptsUrlsByDate.containsKey(
                            creationDate)) {
                          savedReceiptsUrlsByDate[creationDate] = [];
                        }
                        savedReceiptsUrlsByDate[creationDate]!.add(downloadUrl);
                      }
                    }

                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) =>
                            SavedReceiptsPage(savedReceiptsUrlsByDate)));
                  } catch(error){
                    if (error is FirebaseException && error.code == 'permission-denied') {
                      // Handle permission denied error
                      print("Permission denied error occurred.");
                    } else {
                      // Handle other errors
                      print("An error occurred: $error");
                    }
                  };
                },
                child: Text("Generate Report"),
              ),
            ],
          ),]
        ),
      ),
    );
  }
}