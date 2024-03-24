import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_learning/Models/ListeningModels.dart';
import 'package:english_learning/Models/ReadingModels.dart';
import 'package:english_learning/Models/Users_ThiDocModels.dart';
import 'package:english_learning/Pages/ListeningTestForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ReadingTestForm.dart';

class CT_Listening extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CT_Listening();
}

class _CT_Listening extends State<CT_Listening> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Listening Test'),
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
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => ListeningTestform(
                                                made: e.made.toString(),url_audio: e.url_audio.toString()
                                              )));
                                },
                                child: Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    padding: EdgeInsets.all(15.0),
                                    height: 100.0,
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
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
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
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
                                              e.socau.toString() + " câu",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              'Start now!',
                                              style: TextStyle(
                                                  color: Colors.white),
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

  Stream<List<ListeningModels>> _readData() {
    final readingCollection =
        FirebaseFirestore.instance.collection('LuyenThiNghe').orderBy('name');

    return readingCollection
        .snapshots()
        .map((querySnapShot) => querySnapShot.docs
            .map(
              (e) => ListeningModels.fromSnapShot(e),
            )
            .toList());
  }
}
