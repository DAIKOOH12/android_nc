class Users_ThiDocModels{
  String? id;
  String? diem;
  String? solanlam;
  Users_ThiDocModels({this.id, this.diem, this.solanlam});

  Map<String,dynamic> toJSON(){
    return {
      'id':id,
      'diem':diem,
      'solanlam':solanlam
    };
  }
}