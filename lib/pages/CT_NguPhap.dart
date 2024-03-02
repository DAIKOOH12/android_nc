// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:german_for_u/pages/BT_nguPhap.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';


class CT_nguPhap extends StatefulWidget {
  String idNguPhap;
  String link;
  CT_nguPhap({super.key, required this.idNguPhap, required this.link});

  @override
  State<CT_nguPhap> createState() => _newState();
}

class _newState extends State<CT_nguPhap> {

  String urlPDFPath = "";
  bool loaded = false;



  Future<File> getFileFromUrl(String url) async {
    var data = await http.get(Uri.parse(url));
    var bytes = data.bodyBytes;
    var dir = await getApplicationDocumentsDirectory();
    File file = File("${dir.path}/" + "testonline.pdf");
    File urlFile = await file.writeAsBytes(bytes);
    return urlFile;
  }

  @override
  void initState() {
    getFileFromUrl(widget.link).then(
          (value) => {
        setState(() {
          urlPDFPath = value.path;
          loaded = true;
        })
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.green,
          appBar: AppBar(),
          // body: SfPdfViewer.network("https://firebasestorage.googleapis.com/v0/b/german-for-u.appspot.com/o/tudehoi.pdf?alt=media&token=1a78a2d7-9cb4-4926-aed9-05cfb2c4382c"),
          // body: SfPdfViewer.network("https://firebasestorage.googleapis.com/v0/b/german-for-u.appspot.com/o/tudehoi.pdf?alt=media&token=1a78a2d7-9cb4-4926-aed9-05cfb2c4382c")
          body: SingleChildScrollView(
            child: Column(
              children: [
                // SfPdfViewer.network("https://firebasestorage.googleapis.com/v0/b/german-for-u.appspot.com/o/tudehoi.pdf?alt=media&token=1a78a2d7-9cb4-4926-aed9-05cfb2c4382c"),
                loaded ? Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 40),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: PDFView(
                      enableSwipe: true,
                      swipeHorizontal: false,
                      autoSpacing: false,
                      pageSnap: true,
                      pageFling: false,
                      onError: (error) {
                        print(error.toString());
                      },
                      filePath: urlPDFPath,
                      // swipeHorizontal: true,
                    ),
                  ),
                ) : Center(child: CircularProgressIndicator()),

                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return BT_NguPhap(id: widget.idNguPhap,);
                      })
                    );
                  },
                  color: Colors.blue,
                  child: Text("Luyện tập"),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }


  // String aa = "";
  //
  // Future getContent() async {
  //   final a = await FirebaseFirestore.instance.collection('CTHT - nguPhap').get();
  //
  //   a.docs.forEach((element) {
  //     setState(() {
  //       aa = element['ff'];
  //     });
  //   });
  //
  // }
  //
  //
  // @override
  // void initState() {
  //   super.initState();
  //   getContent();
  // }
  //
  // @override
  // Widget build(BuildContext context) {
  //   return Material(
  //     child: SafeArea(
  //       child: Scaffold(
  //         appBar: AppBar(),
  //         body: PDFView(
  //           filePath: "https://firebasestorage.googleapis.com/v0/b/german-for-u.appspot.com/o/tudehoi.pdf?alt=media&token=1a78a2d7-9cb4-4926-aed9-05cfb2c4382c",
  //           enableSwipe: true,
  //           swipeHorizontal: false,
  //           autoSpacing: false,
  //           pageSnap: true,
  //           pageFling: false,
  //           onError: (error) {
  //             print(error.toString());
  //           },
  //         )
  //       ),
  //     ),
  //   );
  // }
}
