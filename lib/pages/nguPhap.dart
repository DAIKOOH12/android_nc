import 'package:flutter/material.dart';
import 'package:german_for_u/pages/test.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class nguPhap extends StatefulWidget {
  const nguPhap({super.key});

  @override
  State<nguPhap> createState() => _nguPhapState();
}

class _nguPhapState extends State<nguPhap> {


  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(

          children: [
            Center(
              child: Text(
                'Trình độ hiện tại: A1',
                style: TextStyle(
                  fontSize: 24
                ),

              ),
            ),


            Expanded(

              child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 25,);
                },
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context){
                          return newT();
                          }));

                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: size.width * 0.85,
                      decoration: BoxDecoration(
                          color: Color(0xFF006A0B),
                          borderRadius: BorderRadius.circular(18)
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Konjugation der Verben',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20
                                  ),
                                ),
                                Text(
                                  '(Chia động từ)',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20
                                  ),
                                )
                              ],
                            ),
                          ),
                          // SizedBox(width: 20,),
                          Positioned(
                            // top: ,
                            right: 10,
                            top: 0,
                            bottom: 0,
                            child: CircularPercentIndicator(
                              radius: 25,
                              lineWidth: 5,
                              percent: 0.7,
                              progressColor: Color(0xFF0EAD00),
                              backgroundColor: Colors.white,
                              center: Text('70%', style: TextStyle(color: Colors.white),),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                itemCount: 12,
              ),
            ),

          ],
        ),
    );
  }
}
