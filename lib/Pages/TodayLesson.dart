
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class TodayLesson extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>_TodayLesson();
}
class _TodayLesson extends State<TodayLesson>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ngữ Pháp'),
        centerTitle: true,
      ),
      body: SfPdfViewer.asset('assets/pdf/thi-hien-tai-don-trong-tieng-anh.pdf'),
    );
  }
}