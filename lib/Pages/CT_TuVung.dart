import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_learning/Models/TuNguModels.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CT_TungVung extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CT_TungVung();
}

class _CT_TungVung extends State<CT_TungVung> {
  final FlutterTts flutterTts = FlutterTts();
  List<String> lstFavorites=[];
  String? user;
  Future<void> loadFavorites() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      user = pref.getString('auth_token');
      lstFavorites=pref.getStringList(user!+'_Favorites')??[];
    });
  }
  Future<void> setFavorites(List<String> favorites) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    user = pref.getString('auth_token');
    pref.setStringList(user!+'_Favorites',favorites);
  }

  void checkExist(String favorites){
    if(lstFavorites.contains(favorites)){
      Fluttertoast.showToast(
          msg: 'Đã tồn tại từ này trong Favorites',
        fontSize: 20
      );
    }else{
      lstFavorites.add(favorites);
      setFavorites(lstFavorites);
      _showToast(context);
    }
  }
  @override
  void initState() {
    loadFavorites();
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.hideCurrentSnackBar();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Từ vựng TOEIC'),
        centerTitle: true,
      ),
      body: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          Center(
            child: Column(
              children: [
                StreamBuilder(
                    stream: _readData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.data == null) {
                        return Center(
                          child: Text('No data'),
                        );
                      }
                      final tuvung = snapshot.data;
                      return Column(
                        children: tuvung!.map((e) {
                          String engword=e.engword.toString();
                          String vieword=e.vieword.toString();
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(15)),
                              child: ListTile(
                                title: Text(
                                  engword,
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  vieword,
                                  style: TextStyle(color: Colors.white),
                                ),
                                trailing: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0,3,0,5),
                                      child: GestureDetector(
                                        onTap: () {
                                          checkExist(e.engword.toString());
                                          print(lstFavorites);
                                        },
                                        child: Icon(
                                          Icons.favorite,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        speakOut(engword);
                                      },
                                      child: Icon(
                                        Icons.volume_up_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }

  void speakOut(String text) async {
    await flutterTts.setLanguage('en-EN');
    await flutterTts.setPitch(1.5);
    await flutterTts.speak(text);
  }

  Stream<List<TuNguModels>> _readData() {
    final tunguCollection = FirebaseFirestore.instance.collection('TuVung').orderBy('engword');

    return tunguCollection.snapshots().map((querySnapShot) => querySnapShot.docs
        .map(
          (e) => TuNguModels.fromSnapShot(e),
        )
        .toList());
  }
  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Added to favorite'),
        duration: Duration(milliseconds: 600),
      ),
    );
    // Future.delayed(Duration(milliseconds: 100),(){
    //   scaffold.hideCurrentSnackBar;
    // });
  }
}
