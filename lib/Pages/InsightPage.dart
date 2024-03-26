import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_learning/Models/ReadingModels.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../Models/ListeningModels.dart';
import '../Models/Users_ThiDocModels.dart';
import '../Models/Users_ThiNgheModels.dart';

class InsightPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InsightPage();
}

class _InsightPage extends State<InsightPage> {
  late int userReadingDone;
  late int userListeningDone;
  late int readingTestCount;
  late int listeningTestCount;
  List<String> lstFavorites=[];
  String? user = '';
  bool isLoading=true;
  Future<void> _loadData() async {
    //Lấy tổng số bài đọc
    final readingTest=await FirebaseFirestore.instance.collection('LuyenThiDoc').get();
    if(readingTest.docs.isNotEmpty){
      readingTestCount=readingTest.docs.length;
    }

    //Lấy tổng số bài nghe
    final listeningTest=await FirebaseFirestore.instance.collection('LuyenThiNghe').get();
    if(listeningTest.docs.isNotEmpty){
      listeningTestCount=listeningTest.docs.length;
    }
    
    //Lấy bài đọc đã làm của user
    final userThiDoc = await FirebaseFirestore.instance
        .collection('Users_ThiDoc')
        .where('email', isEqualTo: user)
        .get();
    if (userThiDoc.docs.isNotEmpty) {
      userReadingDone=userThiDoc.docs.length;
    }
    else{
      userReadingDone=0;
    }
    //Lấy bài nghe đã làm của user
    final userThiNghe = await FirebaseFirestore.instance
        .collection('Users_ThiNghe')
        .where('email', isEqualTo: user)
        .get();
    if (userThiNghe.docs.isNotEmpty) {
      userListeningDone=userThiNghe.docs.length;
    }
    else{
      userListeningDone=0;
    }
    setState(() {
      isLoading=false;
    });
  }
  Future<void> loadFavorites() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      user = pref.getString('auth_token');
      lstFavorites=pref.getStringList(user!+'_Favorites')??[];
    });
  }
  Future<void> _loadUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    user = pref.getString('auth_token');
    setState(() {});
    Future.delayed(Duration(seconds: 1),(){
      loadFavorites();
      _loadData();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _loadUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading?Center(child: CircularProgressIndicator(),):Scaffold(
        appBar: AppBar(
          title: Text('Thống Kê'),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 1,
                child: Column(
                  children: [
                    Text(
                      'Tiến độ học tập',
                      style: TextStyle(fontSize: 20),
                    ),
                    Column(
                      children: [
                        Text(
                          user!,
                          style: TextStyle(fontSize: 20),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: SfRadialGauge(
                            axes: <RadialAxis>[
                              RadialAxis(
                                minimum: 0,
                                maximum: 100,
                                showLabels: false,
                                showTicks: false,
                                axisLineStyle: AxisLineStyle(
                                  thickness: 0.1,
                                  cornerStyle: CornerStyle.bothCurve,
                                  color: Color.fromRGBO(210, 210, 210, 1.0),
                                  thicknessUnit: GaugeSizeUnit.factor,
                                ),
                                pointers: [
                                  RangePointer(
                                    value: 6 / 10 * 100,
                                    cornerStyle: CornerStyle.bothCurve,
                                    width: 0.1,
                                    sizeUnit: GaugeSizeUnit.factor,
                                    color: Colors.blue,
                                  )
                                ],
                                annotations: [
                                  GaugeAnnotation(
                                    positionFactor: 0.1,
                                    angle: 90,
                                    widget: Container(
                                      child: CircleAvatar(
                                        radius: 85,
                                        backgroundImage: AssetImage(
                                            'assets/images/insight_avatar.jpg'),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 120,
                            width: 140,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(238, 238, 238, 1.0),
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    userReadingDone.toString()+'/'+readingTestCount.toString(),
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Reading Test',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color:
                                        Color.fromRGBO(171, 171, 171, 1.0)),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 120,
                            width: 140,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(238, 238, 238, 1.0),
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    userListeningDone.toString()+'/'+listeningTestCount.toString(),
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Listening Test',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color:
                                        Color.fromRGBO(171, 171, 171, 1.0)),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 120,
                            width: 140,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(238, 238, 238, 1.0),
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    lstFavorites.length.toString(),
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Favorite Words',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color:
                                        Color.fromRGBO(171, 171, 171, 1.0)),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 120,
                            width: 140,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(238, 238, 238, 1.0),
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '0/1',
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Examination',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color:
                                        Color.fromRGBO(171, 171, 171, 1.0)),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
