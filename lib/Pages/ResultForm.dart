import 'package:english_learning/Pages/CT_Reading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ResultForm extends StatefulWidget{
  int total;
  int result;
  ResultForm({required this.total, required this.result});
  @override
  State<StatefulWidget> createState() =>_ResultForm();
}

class _ResultForm extends State<ResultForm>{

  String congracText='';
  void loadCongrac(){
    double percent=widget.result/widget.total*100;
    if(percent<25&&percent>0){
      setState(() {
        congracText='Không sao! Có công mài sắt có ngày nên kim';
      });
    }
    if(percent<50){
      setState(() {
        congracText='Tôi tin bạn có thể có kết quả tốt hơn!';
      });
    }
    if(percent<100){
      setState(() {
        congracText='Thật tuyệt vời! Bạn sắp thành công rồi đó!';
      });
    }
    if(percent==100){
      setState(() {
        congracText='Quá hoàn hảo! What a great user!';
      });
    }
  }
  @override
  void initState() {
    super.initState();
    loadCongrac();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CHÚC MỪNG!'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height*1,
            child: Column(
              children: [
                SfRadialGauge(
                  axes: <RadialAxis>[
                    RadialAxis(
                      minimum: 0,
                      maximum: 100,
                      showLabels: false,
                      showTicks: false,
                      axisLineStyle: AxisLineStyle(
                        thickness: 0.2,
                        cornerStyle: CornerStyle.bothCurve,
                        color: Color.fromRGBO(210, 210, 210, 1.0),
                        thicknessUnit: GaugeSizeUnit.factor,
                      ),
                      pointers: [
                        RangePointer(
                          value: widget.result/widget.total*100,
                          cornerStyle: CornerStyle.bothCurve,
                          width: 0.2,
                          sizeUnit: GaugeSizeUnit.factor,
                          color: Colors.blue,
                        )
                      ],
                      annotations: [
                        GaugeAnnotation(
                          positionFactor: 0.1,
                          angle: 90,
                          widget: Text(
                            widget.result.toString()+'/'+widget.total.toString(),
                            style: TextStyle(
                              fontSize: 30
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                Text('Tôi biết bạn có thể đạt được điểm tốt hơn mà! Cố gắng lên nhé!',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30,),
                ElevatedButton(onPressed: (){
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context)=>CT_Reading()),
                          (route) => false);
                },
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text("Let's roll back!",
                      style: TextStyle(color: Colors.white),),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      elevation: 4,
                    ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}