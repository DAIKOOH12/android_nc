import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_learning/Models/ReadingModels.dart';
import 'package:english_learning/Models/Users_ThiDocModels.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ReadingTestForm.dart';

class CT_Reading extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CT_Reading();
}

class _CT_Reading extends State<CT_Reading> {
  int getReadingCount = 0;
  int getUserReadingCount = 0;
  int index = -1;
  int defaultIndex=0;
  bool userDone=false;
  List<Users_ThiDocModels> lstDeUser = [];
  List<ReadingModels> lstReading = [];
  bool isLoading = false;
  String lastPoint = '';

  Future _loadResult() async {
    final ctReading = await FirebaseFirestore.instance
        .collection('LuyenThiDoc')
        .orderBy('name')
        .get();
    if (ctReading.docs.isNotEmpty) {
      ctReading.docs.forEach((element) {
        lstReading.add(new ReadingModels(
            made: element['made'],
            name: element['name'],
            socau: element['socau'],
            time: element['time']));
      });
    }
    getReadingCount = lstReading.length;
    print('Số đề hiện tại $getReadingCount');

    for (int i = 0; i < getReadingCount; i++) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? user = pref.getString('auth_token');
      String userResult = user.toString() + "_" + lstReading[i].made.toString();
      print('Check mã đề theo user $userResult');
      final lastResult = await FirebaseFirestore.instance
          .collection('Users_ThiDoc')
          .where("id", isEqualTo: userResult)
          .get();

      if (lastResult.docs.isNotEmpty) {
        lastResult.docs.forEach((element) {
          lstDeUser.add(new Users_ThiDocModels(
              id: element['id'],
              diem: element['diem'],
              solanlam: element['solanlam']));
        });
      }
    }
    getUserReadingCount = lstDeUser.length;
    setState(() {});
    if (getReadingCount != 0) {
      setState(() {
        isLoading = true;
      });
    }
    print('Đề có điểm '+lstDeUser.length.toString());
    if(getReadingCount!=0){
      setState(() {
        userDone=true;
      });
    }

    // lastPoint=lstDeUser[0].diem.toString();
  }
  String checkUserDone(String lastResult){
    if(userDone){
      return lastResult;
    }
    return '0';
  }
  @override
  void initState() {
    _loadResult();
    super.initState();
  }

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
                      return isLoading
                          ? Column(
                              children: readingTest!.map((e) {
                                print('Chỉ số $index');
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
                                                builder: (context) => ReadingTestForm(
                                                      made: e.made.toString(),
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
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
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                    e.time.toString() + " phút",
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
                            )
                          : CircularProgressIndicator();
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
