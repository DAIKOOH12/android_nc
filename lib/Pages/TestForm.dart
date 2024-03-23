import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_learning/Models/TestFormModels.dart';
import 'package:english_learning/Models/Users_ThiDocModels.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestForm extends StatefulWidget {
  String? made;

  TestForm({required this.made});

  @override
  State<StatefulWidget> createState() => _TestForm();
}

class _TestForm extends State<TestForm> {
  bool isLoading=false;
  int tongdiem=0;
  String? getMaDe;
  List<TestFormModels> lstTest = [];
  var index = 0;
  late String? user='';

  // var cauTheoMaDe;
  void initState() {
    _loadData();
    loadUser();
    super.initState();
  }

  Future<void> loadUser()async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    setState(() {
      user=pref.getString('auth_token');
    });
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


  Future _updateDiem(String? user,String made,String diem,String solanlam) async{
    final idTest =user.toString()+'_'+made;
    final userTest=await FirebaseFirestore.instance.collection('Users_ThiDoc').where('id',isEqualTo: idTest).get();


    if(userTest.docs.isNotEmpty){
      print('Lấy được');
    }else{
      Users_ThiDocModels newTest=Users_ThiDocModels(id: idTest,diem: diem,solanlam: solanlam);
      _createResult(newTest,idTest);
      setState(() {
        isLoading=true;
      });
    }
  }

  void _createResult(Users_ThiDocModels users_thiDocModels,String idTest){
    final testCollection=FirebaseFirestore.instance.collection('Users_ThiDoc');

    String id=idTest;

    final newTest=Users_ThiDocModels(
      id: users_thiDocModels.id,
      diem: users_thiDocModels.diem,
      solanlam: users_thiDocModels.solanlam
    ).toJSON();

    testCollection.doc(id).set(newTest);
  }
  @override
  String warningText = '';
  int selectedOption = 0;

  @override
  Widget build(BuildContext context) {
    return isLoading?Center(child: CircularProgressIndicator(),):Scaffold(
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
                              tongdiem++;
                            });
                            Future.delayed(Duration(milliseconds: 900), () {
                              setState(() {
                                if (index == lstTest.length - 1) {
                                  String? made=this.getMaDe;
                                  String user=this.user!;

                                  _updateDiem(user, made!,tongdiem.toString(),1.toString());
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
                                  String? made=this.getMaDe;
                                  String user=this.user!;

                                  _updateDiem(user, made!,tongdiem.toString(),1.toString());
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
