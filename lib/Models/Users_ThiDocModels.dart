class Users_ThiDocModels{
  String? id;
  String? diem;
  String? solanlam;
  String? email;
  Users_ThiDocModels({this.id, this.diem, this.solanlam,this.email});

  Map<String,dynamic> toJSON(){
    return {
      'id':id,
      'diem':diem,
      'solanlam':solanlam,
      'email':email
    };
  }
}