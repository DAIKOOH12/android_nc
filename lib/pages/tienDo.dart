import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:german_for_u/pages/CT_tienDoHomNay.dart';
import 'package:german_for_u/pages/tienDoHomNay.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:table_calendar/table_calendar.dart';

import '../obj/obj_tienDo.dart';
class tienDo extends StatefulWidget {
  const tienDo({super.key});

  @override
  State<tienDo> createState() => _tienDoState();
}

class _tienDoState extends State<tienDo> {

  DateTime dateToday = DateTime.now();
  String date= "";
  int day = 0;
  int year = 0;
  int month = 0;
  late Future<void> _future;

  late DateTime _lastDayOfMonth;

  int length = 0;

  List<obj_tienDo> listTienDo = [];

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
      // print(nghe);
      setState(() {
        // listPercent[index] = (tuVung+nguPhap+nghe)/30;
        listTienDo[index].nghe = nghe/60;
        listTienDo[index].tuVung = tuVung/60;
        listTienDo[index].nguPhap = nguPhap/60;
        listTienDo[index].percent = (tuVung+nguPhap+nghe)/60;
        // print(listTienDo[index].percent);
      });
    }


  }

  void setListTienDo () {
    DateTime lastDay =getNgayCuoiThang();
    // int length = DateTime.utc(lastDay.year, lastDay.month, lastDay.day).difference(DateTime.utc(year,month,day)).inDays +1;
    // print(year);
    setState(() {
      // listPercent = List.generate(7, (index) => 0);
      length = DateTime.utc(lastDay.year, lastDay.month, lastDay.day).difference(DateTime.utc(year,month,day)).inDays +1;
      listTienDo = List.generate(length, (index) => obj_tienDo(0.0, 0.0, 0.0, 0.0));
      // yesterday = thu.subtract(Duration(days: 1));
      // print(yesterday);
      // print(length);
      // print(day);
    });
  }

  void setList ( ) {
    // print(length);
    for (int i=0;i<length ;i ++) {
      setState(() {
        getPercent(getDay(length-i), i);
      });
    }
  }

  String getDay (int index) {
    DateTime dt = getNgayCuoiThang().subtract(Duration(days: index));
    // print(dt.day.toString() + dt.month.toString() + dt.year.toString());
    // print(dt);
    return dt.day.toString() + "/" + dt.month.toString() +"/" + dt.year.toString();
  }

  void _onDaySelected(DateTime day, DateTime focusedDay){
    // setState(() {
    //   dateToday = day;
    // });
  }

  DateTime getNgayCuoiThang () {
    DateTime now = DateTime.now();

    // Tạo một DateTime đại diện cho ngày đầu tiên của tháng tiếp theo
    DateTime firstDayOfNextMonth = DateTime(now.year, now.month + 1, 1);

    // Trừ đi một ngày để lấy ngày cuối cùng của tháng hiện tại
    DateTime lastDayOfMonth = firstDayOfNextMonth.subtract(Duration(days: 1));
    // print(lastDayOfMonth.day);
    return lastDayOfMonth;
  }

  Future<void> getFirstDay () async {
    final user = await FirebaseAuth.instance.currentUser!;
    final gfd = await FirebaseFirestore.instance.collection('user')
    .doc(user.email.toString())
    .get();

    if(gfd.exists) {
      setState(() {
      date = gfd['dNgayBatDau'];
      day = int.parse(date.split('/')[0]);
      // print(day);
      month = int.parse(date.split('/')[1]);
      year = int.parse(date.split('/')[2]);
      });
    }

    setListTienDo();
    setList();


    // print(date);
    // var lst = list.split('/');

     // print(year);
     // print(month);
     // print(day);
    // print(date.split('/'));
  }

  // void getDate() {
  //   getFirstDay().then((value) {
  //     setState(() {
  //       date = value;
  //     });
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // getNgayCuoiThang();
    _future = getFirstDay();
    _lastDayOfMonth = getNgayCuoiThang();
    // setListTienDo();
    // setList();
    // print(listTienDo[1]);
    // getDate();
  }

  @override
  Widget build(BuildContext context) {





    DateTime _firstDay = DateTime.utc(year, month, day);
    DateTime _lastDay = DateTime(dateToday.year, dateToday.month, getNgayCuoiThang().day);

    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: FutureBuilder<void> (
        future: _future,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError ) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return TableCalendar(
              locale: 'en_US',
              headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false
              ),
              focusedDay: dateToday,
              firstDay: _firstDay,
              lastDay: _lastDay,
              onDaySelected: _onDaySelected,
              calendarStyle: CalendarStyle(
                selectedTextStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 23),

              ),
              // selectedDayPredicate: (day)=>isSameDay(day, dateToday),
              rowHeight: 90,

              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  int soNgay = _lastDayOfMonth.difference(day).inDays;
                  // print(listTienDo);

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return CT_tienDoHomNay(tienDo: listTienDo[length-1-soNgay],);
                      }));

                    },
                    child: Column(
                      children: [
                        Center(child: Text(day.day.toString())),
                        SizedBox(height: 7,),
                        Container(
                          // padding: EdgeInsets.symmetric(horizontal: 20),
                          // margin: EdgeInsets.symmetric(horizontal: 20),
                          child: CircularPercentIndicator(
                            radius: 17,
                            // backgroundWidth: ,
                            lineWidth: 8,

                            // percent: listTienDo[length -1 - soNgay].percent/30,
                            percent: (listTienDo[length -1 - soNgay].percent - (listTienDo[length -1 - soNgay].percent ~/ 30) * 30)/30,
                            animation: true,
                            animationDuration: 2000,
                            progressColor: listTienDo[length -1 - soNgay].percent <= 30 ? Color(0xFF0EAD00) : Colors.green[900],
                            backgroundColor: listTienDo[length -1 - soNgay].percent <= 30 ? Colors.blueGrey.shade200 : Color(0xFF0EAD00),
                            circularStrokeCap: CircularStrokeCap.round,
                            // center: Text('70%', style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ],
                    ),
                  );
                  // return CircularPercentIndicator(
                  //   radius: 25,
                  //   lineWidth: 5,
                  //   percent: 0.7,
                  //
                  //   progressColor: Color(0xFF0EAD00),
                  //   backgroundColor: Colors.white,
                  //   center: Text('70%', style: TextStyle(color: Colors.white),),
                  // );
                },

              ),
            );
          }
        },
      )
    );


  }
}
