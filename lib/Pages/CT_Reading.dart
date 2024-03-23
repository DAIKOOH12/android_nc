import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_learning/Models/ReadingModels.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'TestForm.dart';

class CT_Reading extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CT_Reading();
}

class _CT_Reading extends State<CT_Reading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Reading Test'),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Column(
              children: [
                StreamBuilder(
                    stream: _readData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.data == null) {
                        return Center(
                          child: Text('No data'),
                        );
                      }
                      final readingTest = snapshot.data;
                      return Column(
                        children: readingTest!.map((e) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context,
                                      CupertinoPageRoute(builder: (context)=>TestForm(made: e.made.toString(),))
                                  );
                                },
                                child: Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(15)),
                                    padding: EdgeInsets.all(15.0),
                                    height: 100.0,
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Row(
                                      children: [
                                        Image(
                                            image: AssetImage(
                                                'assets/images/testing.png')),
                                        SizedBox(width: 10),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              e.name.toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              "Bắt đầu thi thử",
                                              style:
                                                  TextStyle(color: Colors.white),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              e.socau.toString()+" câu",
                                              style:
                                                  TextStyle(color: Colors.white),
                                            ),
                                            Text(
                                              e.time.toString()+" phút",
                                              style:
                                                  TextStyle(color: Colors.white),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      );
                    })
              ],
            ),
          ],
        ));
  }

  Stream<List<ReadingModels>> _readData() {
    final readingCollection =
        FirebaseFirestore.instance.collection('LuyenThiDoc').orderBy('name');

    return readingCollection
        .snapshots()
        .map((querySnapShot) => querySnapShot.docs
            .map(
              (e) => ReadingModels.fromSnapShot(e),
            )
            .toList());
  }
}
