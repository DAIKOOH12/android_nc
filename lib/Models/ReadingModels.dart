import 'package:cloud_firestore/cloud_firestore.dart';

class ReadingModels {
  String? made;
  String? name;
  String? socau;
  String? time;

  ReadingModels({this.made, this.name, this.socau, this.time});

  static ReadingModels fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return ReadingModels(
        made: snapshot['made'],
        name: snapshot['name'],
        socau: snapshot['socau'],
        time: snapshot['time']);
  }
}
