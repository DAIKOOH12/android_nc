import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:german_for_u/obj/obj_BTNguPhap.dart';
class BT_NguPhap extends StatefulWidget {
  String id;
  BT_NguPhap({super.key, required this.id});

  @override
  State<BT_NguPhap> createState() => _BT_NguPhapState();
}

class _BT_NguPhapState extends State<BT_NguPhap> {

  List<obj_BTNguPhap> listBT = [];
  bool start = false;
  String? selectAnswer;
  int ind = 0;
  List<String> selectedAnswer = [];
  List<String> lstDapAn = [];
  int scd= 0;

  @override
  void initState() {
    super.initState();
    getBaiTap();
  }
  
  Future getBaiTap() async {
    final Fs_BT = await FirebaseFirestore.instance.collection('CT_NguPhap')
        .where('sMaNguPhap', isEqualTo: widget.id)
        .get();

    if (Fs_BT.docs.isNotEmpty) {
      Fs_BT.docs.forEach((element) {
        listBT.add(new obj_BTNguPhap(
            element.id,
            element['sDeBai'],
            element['sNoiDung'],
            element['a'],
            element['b'],
            element['c'],
            element['d'],
            element['sDapAn']));
      });
    }

    setState(() {
      lstDapAn = List.generate(listBT.length, (index) => "");
      selectedAnswer = List.generate(listBT.length, (index) => "");
      listBT.sort((a, b) {
        int a1 = int.parse(a.noiDung
            .split(".")
            .first);
        int b1 = int.parse(b.noiDung
            .split(".")
            .first);
        return a1.compareTo(b1);
      });
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2), // Thời gian hiển thị SnackBar
      ),
    );
  }

  void _showTemporaryDialog(BuildContext context, String text, bool trangThai) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text('Thông báo'),
          content: Row(
            children: [
              Icon(trangThai ? Icons.check_circle_outlined : Icons.error,
                color: trangThai ? Colors.green : Colors.red,
                size: 40,),
              SizedBox(width: 7,),
              Expanded (
                child: Text(text,

                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 19,
                      color: trangThai ? Colors.green : Colors.red
                  ),),
              ),
            ],
          ),
        );
      },
    );

    // Đóng hộp thoại sau 2 giây
    Future.delayed(Duration(milliseconds: 1500), () {
      // Kiểm tra xem hộp thoại có đang hiển thị không
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(); // Đóng hộp thoại
      }
    });
  }


  void _showKetQua(BuildContext context, String scd, String tong) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Bạn đã hoàn thành bài '
                'với kết quả: '+ scd + "/" + tong),
            actions: <Widget>[
              TextButton(
                onPressed: () => {
                  Navigator.of(context).pop(false),
                  Navigator.of(context).pop(),
                },
                child: Text('OK'),
              ),

            ],
          );

        }

    );
  }
  
  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.green[100],
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                if(start == true) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Bạn có chắc muốn thoát không?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('Không'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Thêm mã để dừng video tại đây
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: Text('Có'),
                        ),
                      ],
                    ),
                  );
                }
                else {
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
          body: Column(
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  height: 400,
                  width: size.width * 0.85,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.grey[200]
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: listBT.isNotEmpty ? Text(listBT[ind].deBai) : SizedBox(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: listBT.isNotEmpty ? Text(listBT[ind].noiDung) : SizedBox(),
                      ),
                      Expanded(
                        child: ListView(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.all(16.0),
                          children: [
                            if(listBT.isNotEmpty) ... [
                              RadioListTile<String>(
                                title: listBT.isNotEmpty ? Text(listBT[ind].A) : CircularProgressIndicator(),
                                value: 'A',
                                groupValue: selectedAnswer[ind],
                                onChanged: (value) {
                                  setState(() {
                                    selectedAnswer[ind] = value!;
                                  });
                                  lstDapAn[ind] = "A";
                                },

                              ),
                              RadioListTile<String>(
                                title: listBT.isNotEmpty ? Text(listBT[ind].B) : CircularProgressIndicator(),
                                value: 'B',
                                groupValue: selectedAnswer[ind],
                                onChanged: (value) {
                                  setState(() {
                                    selectedAnswer[ind] = value!;
                                  });
                                  lstDapAn[ind] = "B";
                                },
                              ),
                              if(listBT[ind].C != "") ... [
                                RadioListTile<String>(
                                  title: listBT.isNotEmpty ? Text(listBT[ind].C) : CircularProgressIndicator(),
                                  value: 'C',
                                  groupValue: selectedAnswer[ind],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedAnswer[ind] = value!;
                                    });
                                    lstDapAn[ind] = "C";
                                  },
                                ),
                              ],
                              if(listBT[ind].D != "") ... [
                                RadioListTile<String>(
                                  title: listBT.isNotEmpty ? Text(listBT[ind].D) : CircularProgressIndicator(),
                                  value: 'D',
                                  groupValue: selectedAnswer[ind],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedAnswer[ind] = value!;
                                    });
                                    lstDapAn[ind] = "D";
                                  },
                                ),
                              ],
                            ]
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30,),

              Center(
                child: MaterialButton(
                  minWidth: 200,
                  height: 60,
                  color: Colors.green,
                  onPressed: () async {
                    start = true;
                    // int count = 0;
                    // for (int i=0; i< listBTL.length; i++) {
                    //   if(lstDapAn[i] == listBTL[i].dapAn){
                    //     count ++;
                    //   }
                    // }
                    // print(count);
                    if(lstDapAn[ind] == ""){
                      _showSnackBar(context, "Bạn chưa chọn đáp án");
                    }
                    else {
                      if(lstDapAn[ind] ==listBT[ind].dapAn){
                        print(lstDapAn[ind]);
                        _showTemporaryDialog(context, "Chính xác", true);
                        scd ++;
                      }
                      else {
                        _showTemporaryDialog(context, "Ôi không đáp án đúng là: " + listBT[ind].dapAn, false);
                        await Future.delayed(Duration(milliseconds: 2200 ));
                      }
                      if(ind<listBT.length - 1)
                        setState(() {
                          ind ++;
                        });
                      else {
                        _showKetQua(context, scd.toString(), lstDapAn.length.toString() );
                      }
                    }


                  },
                  child: Text("Kiểm tra", style: TextStyle(
                      color: Colors.white70
                  ),),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  
}
