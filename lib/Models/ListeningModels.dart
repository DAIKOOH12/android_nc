import 'package:cloud_firestore/cloud_firestore.dart';

class ListeningModels {
  String? made;
  String? name;
  String? socau;
  String? url_audio;

  ListeningModels({this.made, this.name, this.socau, this.url_audio});

  static ListeningModels fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return ListeningModels(
        made: snapshot['made'],
        name: snapshot['name'],
        socau: snapshot['socau'],
        url_audio: snapshot['url_audio']);
  }
}
