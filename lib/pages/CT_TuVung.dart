import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';


class CT_TuVung extends StatefulWidget {
  final String maChuDe;
  final String tenChuDe;

  const CT_TuVung({Key? key, required this.maChuDe, required this.tenChuDe})
      : super(key: key);

  @override
  State<CT_TuVung> createState() => _CT_TuVungState();
}

class _CT_TuVungState extends State<CT_TuVung> {
  List<String> _listTuVung = [];
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    getTuVung();
  }


  Future<void> getTuVung() async {
    final snapShot = await FirebaseFirestore.instance
        .collection('tuVungTheoCD')
        .where('sMaChuDe', isEqualTo: widget.maChuDe.toString())
        .get();

    if (snapShot.docs.isNotEmpty) {
      snapShot.docs.forEach((value) {
        _listTuVung.add(value['sTu']);
      });
    }
    setState(() {
      _listTuVung.sort();
    });
  }

  Future<void> speak(String text) async {
    await flutterTts.setLanguage('de-DE');

    await flutterTts.setPitch(0.8);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.tenChuDe),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  itemCount: _listTuVung.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Center(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        width: size.width * 0.85,
                        height: 100,
                        padding: EdgeInsets.all(18),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(18)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _listTuVung[index],
                              style: TextStyle(
                                  fontSize: 23, fontWeight: FontWeight.w700),
                            ),
                            IconButton(
                              onPressed: () {
                                speak(_listTuVung[index].toString());
                              },
                              icon: Icon(Icons.speaker),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}