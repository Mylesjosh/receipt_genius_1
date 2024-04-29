import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ReceiptService {
  final item1Controller = TextEditingController();

  final price1Controller = TextEditingController();

  final item2Controller = TextEditingController();

  final price2Controller = TextEditingController();

  Future<void> _generateAndSaveReceipt() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Center(child: pw.Text("Receipt", style: pw.TextStyle(fontSize: 24))),
              pw.SizedBox(height: 20),
              _buildItemRow(item1Controller.text, price1Controller.text),
              pw.SizedBox(height: 10),
              _buildItemRow(item2Controller.text, price2Controller.text),
              pw.SizedBox(height: 20),
              _buildTotal(),
            ],
          );
        },
      ),
    );

    final appDocDir = await getApplicationDocumentsDirectory();
    final pdfPath = appDocDir.path + '/receipt.pdf';
    final file = File(pdfPath);
    await file.writeAsBytes(await pdf.save());

    print("Receipt saved as $pdfPath");
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
    final total = double.parse(price1Controller.text) + double.parse(price2Controller.text);
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text("Total:", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.Text(total.toStringAsFixed(2), style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
      ],
    );
  }

}