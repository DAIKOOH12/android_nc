import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_learning/Models/TestFormModels.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestForm extends StatefulWidget {
  String? made;

  TestForm({required this.made});

  @override
  State<StatefulWidget> createState() => _TestForm();
}

class _TestForm extends State<TestForm> {
  String? getMaDe;
  List<TestFormModels> lstTest = [];
  var index = 0;

  // var cauTheoMaDe;
  void initState() {
    _loadData();

    super.initState();
  }

  Future _loadData() async {
    getMaDe = widget.made;
    final cauTheoMaDe = await FirebaseFirestore.instance
        .collection('CT_ThiDoc')
        .where('made', isEqualTo: getMaDe!)
        .get();
    if (cauTheoMaDe.docs.isNotEmpty) {
      cauTheoMaDe.docs.forEach((element) {
        lstTest.add(new TestFormModels(
            made: element['made'],
            question: element['question'],
            A: element['A'],
            B: element['B'],
            C: element['C'],
            D: element['D'],
            awnser: element['awnser']));
      });
    }
    setState(() {});
  }

  @override
  String warningText = '';
  int selectedOption = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GOOD LUCK!'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Text(
                    lstTest.length == 0 ? 'Đang tải' : lstTest[index].question),
                ListTile(
                  title:
                      Text(lstTest.length == 0 ? 'Đang tải' : lstTest[index].A),
                  leading: Radio<int>(
                    value: 1,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value!;
                        print("Button value: $value");
                      });
                    },
                  ),
                ),
                ListTile(
                  title:
                      Text(lstTest.length == 0 ? 'Đang tải' : lstTest[index].B),
                  leading: Radio<int>(
                    value: 2,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value!;
                        print("Button value: $value");
                      });
                    },
                  ),
                ),
                ListTile(
                  title:
                      Text(lstTest.length == 0 ? 'Đang tải' : lstTest[index].C),
                  leading: Radio<int>(
                    value: 3,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value!;
                        print("Button value: $value");
                      });
                    },
                  ),
                ),
                ListTile(
                  title:
                      Text(lstTest.length == 0 ? 'Đang tải' : lstTest[index].D),
                  leading: Radio<int>(
                    value: 4,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value!;
                        print("Button value: $value");
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(warningText),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (selectedOption == 0) {
                        setState(() {
                          warningText = 'Hãy chọn 1 câu trả lời nhé!';
                        });
                      } else {
                        setState(() {
                          print('Bạn chọn $selectedOption');
                          print(lstTest[index].awnser);

                          if (selectedOption ==
                              int.parse(lstTest[index].awnser)) {
                            setState(() {
                              warningText = 'Bạn đã trả lời đúng! Chúc mừng!';
                            });
                            Future.delayed(Duration(milliseconds: 900), () {
                              setState(() {
                                if (index == lstTest.length - 1) {
                                } else {
                                  index++;
                                }
                                selectedOption = 0;
                                warningText = '';
                              });
                            });
                          } else {
                            setState(() {
                              warningText = 'Bạn đã trả lời sai! :<';
                            });
                            Future.delayed(Duration(milliseconds: 900), () {
                              setState(() {
                                if (index == lstTest.length - 1) {
                                } else {
                                  index++;
                                }
                                selectedOption = 0;
                                warningText = '';
                              });
                            });
                          }
                        });
                      }
                    },
                    child: Text('Kiểm tra'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
