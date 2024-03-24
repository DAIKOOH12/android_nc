class Users_ThiNgheModels{
  String? id;
  String? diem;
  String? solanlam;
  Users_ThiNgheModels({this.id, this.diem, this.solanlam});

  Map<String,dynamic> toJSON(){
    return {
      'id':id,
      'diem':diem,
      'solanlam':solanlam
    };
  }
}