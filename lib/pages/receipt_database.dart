import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class SavedReceiptsPage extends StatefulWidget {
  final Map<String, List<String>> savedReceiptsByDate;
  //String receiptName;

  SavedReceiptsPage(this.savedReceiptsByDate, /*this.receiptName*/);


  @override

  State<SavedReceiptsPage> createState() => _SavedReceiptsPageState();
}

class _SavedReceiptsPageState extends State<SavedReceiptsPage> {
  @override
  bool isLoading = true; // Initialize isLoading to true


  Future<void> _downloadReceipt(String pdfUrl) async {
    try {
      // Request permission to access the device's storage
      var status = await Permission.storage.request();
      if (status.isDenied) {
        // Handle the case where the user denies permission
        throw Exception('Permission to access storage denied');
      }

      // Open SAF to let the user choose the directory
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      if (selectedDirectory == null) {
        // Handle the case where the user cancels the directory picker
        print("Directory selection was canceled.");
        return;
      }

      Directory directory = Directory(selectedDirectory);
      File file = File('${directory.path}/receipt_${DateTime.now().millisecondsSinceEpoch}.pdf');

      final httpClient = HttpClient();
      final request = await httpClient.getUrl(Uri.parse(pdfUrl));
      final response = await request.close();
      final bytes = await consolidateHttpClientResponseBytes(response);
      await file.writeAsBytes(bytes);

      // Show a message or perform any other action after downloading the receipt
      print("Receipt downloaded to ${file.path}");
    } catch (e) {
      // Handle any errors that occur during the download process
      print("Error downloading receipt: $e");
    }
  }


  Future<void> _viewReceipt(String pdfUrl) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Receipt Preview"),
          content: Container(
            height: 300, // Adjust the height as needed
            child: SfPdfViewer.network(pdfUrl),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  // Correctly handle the deletion of a receipt
  Future<void> _deleteReceipt(String receiptUrl) async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Receipt'),
          content: Text('Are you sure you want to delete this receipt?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (result == true) {
      // Proceed with deletion
      for (var entry in widget.savedReceiptsByDate.entries) {
        if (entry.value.contains(receiptUrl)) {
          entry.value.remove(receiptUrl);
          if (entry.value.isEmpty) {
            widget.savedReceiptsByDate.remove(entry.key);
          }
          setState(() {});
          break;
        }
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Saved Receipts")),
      body: widget.savedReceiptsByDate.isEmpty
          ? Center(child: Text("No receipts found."))
          : ListView.builder(
        itemCount: widget.savedReceiptsByDate.keys.length,
        itemBuilder: (context, index) {
          final String date = widget.savedReceiptsByDate.keys.elementAt(index);
          final List<String> receiptsForDate = widget.savedReceiptsByDate[date]!;
          return ExpansionTile(
            title: Text(date),
            children: receiptsForDate.map((receiptUrl) {
              return ListTile(
                title: Text("Receipt"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: "view receipt",
                      icon: Icon(Icons.remove_red_eye),
                      onPressed: () => _viewReceipt(receiptUrl),
                    ),
                    IconButton(
                      tooltip: "download receipt",
                      icon: Icon(Icons.download),
                      onPressed: () => _downloadReceipt(receiptUrl),
                    ),
                    IconButton(
                      tooltip: "delete receipt",
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteReceipt(receiptUrl),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
