import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_learning/Models/TuNguModels.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class CT_TungVung extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CT_TungVung();
}

class _CT_TungVung extends State<CT_TungVung> {
  final FlutterTts flutterTts = FlutterTts();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Từ vựng TOEIC'),
        centerTitle: true,
      ),
      body: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          Center(
            child: Column(
              children: [
                StreamBuilder(
                    stream: _readData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.data == null) {
                        return Center(
                          child: Text('No data'),
                        );
                      }
                      final tuvung = snapshot.data;
                      return Column(
                        children: tuvung!.map((e) {
                          String engword=e.engword.toString();
                          String vieword=e.vieword.toString();
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(15)),
                              child: ListTile(
                                title: Text(
                                  engword,
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  vieword,
                                  style: TextStyle(color: Colors.white),
                                ),
                                trailing: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0,3,0,5),
                                      child: GestureDetector(
                                        onTap: () {

                                        },
                                        child: Icon(
                                          Icons.star,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        speakOut(engword);
                                      },
                                      child: Icon(
                                        Icons.volume_up_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }

  void speakOut(String text) async {
    await flutterTts.setLanguage('en-EN');
    await flutterTts.setPitch(1.5);
    await flutterTts.speak(text);
  }

  Stream<List<TuNguModels>> _readData() {
    final tunguCollection = FirebaseFirestore.instance.collection('TuVung');

    return tunguCollection.snapshots().map((querySnapShot) => querySnapShot.docs
        .map(
          (e) => TuNguModels.fromSnapShot(e),
        )
        .toList());
  }
}
