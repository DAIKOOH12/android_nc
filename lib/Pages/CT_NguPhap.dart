import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class CT_NguPhap extends StatelessWidget{
  List<String> detailPDF=[];
  CT_NguPhap({required this.detailPDF});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(detailPDF[0]),
        centerTitle: true,
      ),
      body: Expanded(
        child:SfPdfViewer.network(detailPDF[1]),
      ),
    );
  }

}