import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_learning/Models/NguPhapModels.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'CT_NguPhap.dart';

class NguPhap extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NguPhap();
}

class _NguPhap extends State<NguPhap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Ngữ pháp'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
            ),
            StreamBuilder(
                stream: _readData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data == null) {
                    return Center(child: Text("No data"));
                  }
                  final nguphap = snapshot.data;

                  return Column(
                      children: nguphap!.map((e) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Center(
                                child: Column(
                                  children: [
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width * 0.8,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          List<String> detailNP = [
                                            e.name.toString(),
                                            e.url.toString()
                                          ];
                                          Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      CT_NguPhap(
                                                          detailPDF: detailNP)));
                                        },
                                        child: Text(
                                          e.name.toString(),
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 15),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            backgroundColor: Colors.blue),
                                      ),
                                      height: 100,
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15,),
                      ],
                    );
                  }).toList());
                })
          ],
        ),
      ),
    );
  }

  Stream<List<NguPhapModels>> _readData() {
    final nguphapCollection = FirebaseFirestore.instance.collection('NguPhap');

    return nguphapCollection
        .snapshots()
        .map((querySnapShot) => querySnapShot.docs
            .map(
              (e) => NguPhapModels.fromSnapShot(e),
            )
            .toList());
  }
}
