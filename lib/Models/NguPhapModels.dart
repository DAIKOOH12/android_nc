import 'package:cloud_firestore/cloud_firestore.dart';

class NguPhapModels {
  String? name;
  String? url;

  NguPhapModels({this.name, this.url});

  static NguPhapModels fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return NguPhapModels(name: snapshot['name'], url: snapshot['url']);
  }
}
