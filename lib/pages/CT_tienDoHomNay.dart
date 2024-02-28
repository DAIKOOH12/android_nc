import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:german_for_u/obj/obj_tienDo.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CT_tienDoHomNay extends StatefulWidget {
  obj_tienDo tienDo;
  CT_tienDoHomNay({super.key, required this.tienDo});

  @override
  State<CT_tienDoHomNay> createState() => _CT_tienDoHomNayState();
}

class _CT_tienDoHomNayState extends State<CT_tienDoHomNay> {

  // obj_tienDo tienBo = widget.tienDo;

  double tuVung = 0.0;
  double nguPhap = 0.0;
  double nghe = 0.0;
  double tong = 0.0;
  double _percent = 0.0;

  
  Future getThongSo() async {
    final getTS = await FirebaseFirestore.instance.collection('tienDo')
        .where('sEmail', isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .where('dNgay', isEqualTo: "27/2/2024")
        .get();

    if(getTS.docs.isNotEmpty) {

      getTS.docs.forEach((element) {
        // print(element['iTuVung'].toDouble());
        tuVung = element['iTuVung'].toDouble();
        nghe = element['iNghe'].toDouble();
        nguPhap = element['iNguPhap'].toDouble();
      });
    }
    setState(() {
      tong =(nghe+nguPhap+tuVung);
      _percent = tong/30;
    });

  }


  @override
  void initState() {
    super.initState();
    getThongSo();
    // print((nghe+nguPhap+tuVung)/30.0);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40,),
                Center(
                  child: Container(
                    width: 300,
                    height: 270,
                    // color: Colors.grey,
                    child: Stack(
                      children: [

                        Positioned(
                          // top: 20,
                          left: 0,
                          right: 0,
                          child: CircularPercentIndicator(
                            radius: 120,
                            center: Text((widget.tienDo.percent*100).toStringAsFixed(2)+ "%"),
                            lineWidth: 50,
                            percent: widget.tienDo.percent,
                            circularStrokeCap: CircularStrokeCap.round,
                            animation: true,
                            animationDuration: 2000,
                            progressColor: Color(0xFF0EAD00),
                            backgroundColor: Color(0xFF0EAD00).withOpacity(0.2),
                          ),
                        ),

                        Positioned(
                          top: 7,
                          left: 0,
                          right: 0,
                          child: Icon(Icons.arrow_forward, size: 40,),

                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(right: 20, left: 20,),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Tổng thời gian đã học"),
                      Text(
                        (widget.tienDo.nguPhap +
                            widget.tienDo.tuVung +
                            widget.tienDo.nghe ).toString()+ "/30 phút",
                        style: TextStyle(
                          fontSize: 24,
                          color: Color(0xFF0EAD00),
                        ),
                      )
                    ],
                  ),
                ),

                SizedBox(height: 20,),

                Center(
                  child: Container(
                    width: 300,
                    height: 300,
                    // color: Colors.grey[200],
                    child: BarChart(
                      BarChartData(

                        barTouchData: barTouchData,
                        titlesData: titlesData,
                        borderData: borderData,
                        barGroups: barGroups,
                        // gridData: const FlGridData(show: false),
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 30,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 40,),
              ],
            ),
          ),
        ),
      ),
    );

  }

  BarTouchData get barTouchData => BarTouchData(
    enabled: false,
    touchTooltipData: BarTouchTooltipData(
      tooltipBgColor: Colors.transparent,
      tooltipPadding: EdgeInsets.zero,
      tooltipMargin: 8,
      getTooltipItem: (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
          ) {
        return BarTooltipItem(
          rod.toY.round().toString(),
          const TextStyle(
            color: Color(0xFF50E4FF),
            fontWeight: FontWeight.bold,
          ),
        );
      },
    ),
  );

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Color(0xFF2196F3),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Từ vựng';
        break;
      case 1:
        text = 'Ngữ pháp';
        break;
      case 2:
        text = 'Luyện nghe';
        break;
      // case 3:
      //   text = 'Tu';
      //   break;
      // case 4:
      //   text = 'Fr';
      //   break;
      // case 5:
      //   text = 'St';
      //   break;
      // case 6:
      //   text = 'Sn';
      //   break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }


  FlTitlesData get titlesData => FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        getTitlesWidget: getTitles,
      ),
    ),
    // leftTitles: const AxisTitles(
    //   sideTitles: SideTitles(showTitles: false),
    // ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
  );

  FlBorderData get borderData => FlBorderData(
    show: true,
    border: Border(
      bottom: BorderSide(color: Colors.black),
      left: BorderSide(color: Colors.black)
    )

  );

  List<BarChartGroupData> get barGroups => [
    BarChartGroupData(
      x: 0,
      barRods: [
        BarChartRodData(
          toY: widget.tienDo.tuVung,
          // gradient: _barsGradient,
          width: 25,
            color: Color(0xFF0EAD00).withOpacity(0.6),
          borderRadius: BorderRadius.circular(4)
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 1,
      barRods: [
        BarChartRodData(
          toY: widget.tienDo.nguPhap,
          // gradient: _barsGradient,
            color: Color(0xFF0EAD00).withOpacity(0.6),
            width: 25,
            borderRadius: BorderRadius.circular(4)
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 2,
      barRods: [
        BarChartRodData(
          toY: widget.tienDo.nghe,
          // gradient: _barsGradient,
            color: Color(0xFF0EAD00).withOpacity(0.6),
            width: 25,
            borderRadius: BorderRadius.circular(4)
        )
      ],
      showingTooltipIndicators: [0],
    ),
    // BarChartGroupData(
    //   x: 3,
    //   barRods: [
    //     BarChartRodData(
    //       toY: 15,
    //       gradient: _barsGradient,
    //     )
    //   ],
    //   showingTooltipIndicators: [0],
    // ),
    // BarChartGroupData(
    //   x: 4,
    //   barRods: [
    //     BarChartRodData(
    //       toY: 13,
    //       gradient: _barsGradient,
    //     )
    //   ],
    //   showingTooltipIndicators: [0],
    // ),
    // BarChartGroupData(
    //   x: 5,
    //   barRods: [
    //     BarChartRodData(
    //       toY: 10,
    //       gradient: _barsGradient,
    //     )
    //   ],
    //   showingTooltipIndicators: [0],
    // ),
    // BarChartGroupData(
    //   x: 6,
    //   barRods: [
    //     BarChartRodData(
    //       toY: 16,
    //       gradient: _barsGradient,
    //     )
    //   ],
    //   showingTooltipIndicators: [0],
    // ),
  ];

  LinearGradient get _barsGradient => LinearGradient(
    colors: [
      Color(0xFF0EAD00).withOpacity(0.2),
      Color(0xFF0EAD00),
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

}
