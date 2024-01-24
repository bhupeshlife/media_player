import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfScreen extends StatefulWidget {
  const PdfScreen({super.key});

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      color: Colors.grey,
      child: SfPdfViewer.network(
        'https://www.africau.edu/images/default/sample.pdf',
        onDocumentLoadFailed: (c) {
          print(c.description);
        },
      ),
    );
  }
}
