import 'dart:math';

import 'package:flutter/material.dart';
import 'package:german_for_u/obj/DT_tuVung.dart';

class hocTuVung extends StatefulWidget {
  final List<DT_tuVung> listTuVung;
  final List<String> listTu;
  // final List<String> listLinkAnh;
  const hocTuVung({super.key, required this.listTuVung, required this.listTu});
  // const hocTuVung({super.key, required this.listTu, required this.listNghia, required this.listLinkAnh});

  @override
  State<hocTuVung> createState() => _hocTuVungState();
}

class _hocTuVungState extends State<hocTuVung> {

  late int ind;
  late int indexAnswer;
  late List<String> listRandomAnswer = [];
  Random random =Random();


  @override
  void initState() {
    super.initState();
    ind = 0;
    indexAnswer = random.nextInt(4);
    getListRandomAnswer();
  }

  int getIndexAnswer() {

    return random.nextInt(4);
  }

  void getListRandomAnswer() {
    String answer = "";
    for(int i =0; i<4 ; i++ ){
      answer = widget.listTu[random.nextInt(widget.listTu.length)];
      if(answer != widget.listTuVung[ind].tu)
        listRandomAnswer.add(answer);
      else
        i--;
    }
    setState(() {

    });

  }


  // void _showTemporaryDialog(BuildContext context, String text, bool trangThai) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return showDialog(
  //         // title: Text('Thông báo'),
  //         content: Container(
  //           width: 250,
  //           height: 100,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(7)
  //           ),
  //           // child: Column(
  //           //   children: [
  //           //     Container(
  //           //       width: 250,
  //           //       decoration: BoxDecoration(
  //           //         color: Colors.red
  //           //       ),
            //       child: Row(
            //         children: [
            //           Container(
            //             width: 30,
            //               height: 30,
            //               child: Image.asset("images/sad_face.png")
            //           ),
            //           Text(
            //             'Học từ này!',
            //             style: TextStyle(
            //               color: Colors.white
            //             ),
            //           ),
            //         ],
            //       ),
  //           //     )
  //           //   ],
  //           // ),
  //         ),
  //       );
  //     },
  //   );
  // }

  void _showIncorrectAnswerDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          title: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.only(topRight: Radius.circular(8), topLeft: Radius.circular(8)),
            ),
            child: Row(
              children: [
                SizedBox(width: 10,),
                Container(
                  width: 30,
                  height: 30,
                  child: Image.asset("images/sad_face.png"),
                ),
                SizedBox(width: 15,),
                Text(
                  'Học từ này!',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          content: Column(
            children: [
              Text(
                widget.listTuVung[ind].nghia,
              ),
              Text(
                'Đáp án đúng:',
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
              Text(
                widget.listTuVung[ind].tu,
                style: TextStyle(
                  // color: Colors.green,
                ),
              ),
              Text(
                'Đáp án của bạn:',
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
              Text(
                listRandomAnswer[index],
                style: TextStyle(
                  // color: Colors.green,
                ),
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng cửa sổ dialog
              },
              child: Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text(widget.listTuVung[ind].nghia),
          Container(
            width: 290,
            child: Image.network(widget.listTuVung[ind].linkAnh),
          ),
          Center(
            child: Container(
              width: 290,
              child: ListView.separated(
                itemCount: 4,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if(index != indexAnswer) {
                        _showIncorrectAnswerDialog(context,index);
                      }
                      setState(() {
                        ind ++;
                        indexAnswer = random.nextInt(4);
                        listRandomAnswer.clear();
                        getListRandomAnswer();
                      });
                    },
                    child: Container(
                      width: 290,
                      height: 50,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            index == indexAnswer ? widget.listTuVung[ind].tu
                                : listRandomAnswer[index],
                            style: TextStyle(
                              fontSize: 15
                            ),
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(9)
                      ),
                    ),
                  );
                },

                separatorBuilder: (context, index) => SizedBox(height: 20,),

              ),
            ),
          )
        ],
      )
    );
  }
}
