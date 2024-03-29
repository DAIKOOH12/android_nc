import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:german_for_u/obj/obj_tienDo.dart';
import 'package:german_for_u/pages/CT_tienDoHomNay.dart';
import 'package:german_for_u/pages/tienDo.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class tienDoHomNay extends StatefulWidget {
  const tienDoHomNay({super.key});

  @override
  State<tienDoHomNay> createState() => _tienDoHomNayState();
}

class _tienDoHomNayState extends State<tienDoHomNay> with SingleTickerProviderStateMixin{

  DateTime today = DateTime.now();
  List<String> days = ['Thứ hai', 'Thứ ba', 'Thứ tư', 'Thứ năm', 'Thứ sáu', 'Thứ bảy', 'Chủ nhật'];
  // List<double> listPercent = [];
  List<obj_tienDo> listTienDo = [];

  // DateTime thu = DateTime.utc(2024, 3, 1);
  // DateTime? yesterday;

  TabController? _tabController;

  Future getPercent (String date, int index) async {
    double tuVung = 0, nguPhap=0, nghe=0;
    final getP = await FirebaseFirestore.instance.collection('tienDo')
        .where('sEmail', isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .where('dNgay', isEqualTo: date)
        .get();

    if(getP.docs.isNotEmpty) {
      getP.docs.forEach((element) {
        tuVung = element['iTuVung'].toDouble();
        nguPhap = element['iNguPhap'].toDouble();
        nghe = element['iNghe'].toDouble();
      });
    }

    setState(() {
      // listPercent[index] = (tuVung+nguPhap+nghe)/30;
      listTienDo[index].nghe = nghe/60;
      listTienDo[index].tuVung = tuVung/60;
      listTienDo[index].nguPhap = nguPhap/60;
      listTienDo[index].percent = (tuVung+nguPhap+nghe)/60/30;
      // print(listTienDo[6].percent);
    });
  }

  void setListTienDo () {
    setState(() {
      // listPercent = List.generate(7, (index) => 0);
      listTienDo = List.generate(7, (index) => obj_tienDo(0.0, 0.0, 0.0, 0.0));
      // yesterday = thu.subtract(Duration(days: 1));
      // print(yesterday);
      // print(listTienDo);
    });
  }

  void setList ( ) {
    for (int i=0;i<today.weekday ;i ++) {
      setState(() {
      getPercent(getDay(today.weekday-1-i), i);
      });
    }
  }

  String getDay (int index) {
    DateTime dt = today.subtract(Duration(days: index));
    // print(dt.day.toString() + dt.month.toString() + dt.year.toString());
    return dt.day.toString() + "/" + dt.month.toString() +"/" + dt.year.toString();
  }


  @override
  void initState() {
    super.initState();
    // getPercent("27/2/2024", 1);
    setListTienDo();
    setList();
    _tabController = TabController(length: 7,vsync: this, initialIndex: today.weekday-1); // Thay đổi số 1 thành chỉ số của tab mặc định
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(

            title: Row(
              children: [
                Text(
                  days[today.weekday -1] + " ngày "+
                      today.day.toString() + " thg " +
                      today.month.toString() + ", " +
                      today.year.toString(),
                  style: TextStyle(
                  fontSize: 15
                  ),
                ),
                SizedBox(width: 8,),
                IconButton(
                  icon: Icon(Icons.calendar_month_sharp),
                  color: Colors.green,
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return tienDo();
                      })
                    );
                  },
                )
              ],
            ),

          ),
          body: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: DefaultTabController(
              length: 7,

              child: Column(
                children: [
                  Container(
                    height: kToolbarHeight,
                    child: TabBar(
                      labelColor: Colors.red,
                      // indicatorPadding: EdgeInsets.all(10),
                      physics: ClampingScrollPhysics(),
                      // padding: EdgeInsets.all(10),
                      unselectedLabelColor: Colors.black,
                      indicatorSize: TabBarIndicatorSize.tab,
                      controller: _tabController,
                      indicator: BoxDecoration(
                        // borderRadius: BorderRadius.circular(50),
                        // color: Color(0xff026B00),


                      ),
                      tabs: [
                        Tab(
                          child: Column(
                            children: [
                              Text("T2",
                                style: TextStyle(
                                  // backgroundColor: Colors.green[300],
                                ),
                              ),
                              // SizedBox(height: 3,),
                              CircularPercentIndicator(
                                radius: 12,
                                lineWidth: 5,
                                percent: listTienDo[0].percent,
                                progressColor: Color(0xFF0EAD00),
                              ),
                              // SizedBox(height: 3),
                            ],
                          ),
                        ),
                        Tab(
                          child: Column(
                            children: [
                              Text("T3"),
                              // SizedBox(height: 3,),
                              CircularPercentIndicator(
                                radius: 12,
                                lineWidth: 5,
                                percent: listTienDo[1].percent,
                                progressColor: Color(0xFF0EAD00),
                              ),
                              // SizedBox(height: 3),
                            ],
                          ),
                        ),
                        Tab(
                          child: Column(
                            children: [
                              Text("T4"),
                              // SizedBox(height: 3,),
                              CircularPercentIndicator(
                                radius: 12,
                                lineWidth: 5,
                                percent: listTienDo[2].percent,
                                progressColor: Color(0xFF0EAD00),
                              ),
                              // SizedBox(height: 3),
                            ],
                          ),
                        ),
                        Tab(
                          child: Column(
                            children: [
                              Text("T5"),
                              // SizedBox(height: 3,),
                              CircularPercentIndicator(
                                radius: 12,
                                lineWidth: 5,
                                percent: listTienDo[3].percent,
                                progressColor: Color(0xFF0EAD00),
                              ),
                              // SizedBox(height: 3),
                            ],
                          ),
                        ),
                        Tab(
                          child: Column(
                            children: [
                              Text("T6"),
                              // SizedBox(height: 3,),
                              CircularPercentIndicator(
                                radius: 12,
                                lineWidth: 5,
                                percent: listTienDo[4].percent,
                                progressColor: Color(0xFF0EAD00),
                              ),
                              // SizedBox(height: 3),
                            ],
                          ),
                        ),
                        Tab(
                          child: Column(
                            children: [
                              Text("T7"),
                              // SizedBox(height: 3,),
                              CircularPercentIndicator(
                                radius: 12,
                                lineWidth: 5,
                                percent: listTienDo[5].percent,
                                progressColor: Color(0xFF0EAD00),
                              ),
                              // SizedBox(height: 3),
                            ],
                          ),
                        ),
                        Tab(
                          child: Column(
                            children: [
                              Text("CN"),
                              // SizedBox(height: 3,),
                              CircularPercentIndicator(
                                radius: 12,
                                lineWidth: 5,
                                percent: listTienDo[6].percent,
                                progressColor: Color(0xFF0EAD00),

                              ),
                              // SizedBox(height: 3),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),

                  Expanded(

                    child: TabBarView(
                      controller: _tabController,
                      children: [
                      CT_tienDoHomNay(tienDo: listTienDo[0]),
                      CT_tienDoHomNay(tienDo: listTienDo[1]),
                      CT_tienDoHomNay(tienDo: listTienDo[2]),
                      CT_tienDoHomNay(tienDo: listTienDo[3]),
                      CT_tienDoHomNay(tienDo: listTienDo[4]),
                      CT_tienDoHomNay(tienDo: listTienDo[5]),
                      CT_tienDoHomNay(tienDo: listTienDo[6]),


                    ],),
                  )
                ],
              ),
            ),
          ),

          // body: TabBarView(
          //   children: [
              // Container(
              //   child: Text("t2"),
              // ),
              // Container(
              //   child: Text("t2"),
              // ),
              // Container(
              //   child: Text("t2"),
              // ),
              // Container(
              //   child: Text("t2"),
              // ),
              // Container(
              //   child: Text("t2"),
              // ),
              // Container(
              //   child: Text("t2"),
              // ),
              // Container(
              //   child: Text("t2"),
              // ),
          //   ],
          // ),
        ),
      ),
    );
  }
}
