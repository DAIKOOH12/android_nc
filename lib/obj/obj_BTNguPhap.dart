
class obj_BTNguPhap {
  String _id;
  String _deBai;
  String _noiDung;
  String _A;
  String _B;
  String _C;
  String _D;
  String _dapAn;

  obj_BTNguPhap(this._id, this._deBai, this._noiDung, this._A, this._B, this._C,
      this._D, this._dapAn);

  String get dapAn => _dapAn;

  set dapAn(String value) {
    _dapAn = value;
  }

  String get D => _D;

  set D(String value) {
    _D = value;
  }

  String get C => _C;

  set C(String value) {
    _C = value;
  }

  String get B => _B;

  set B(String value) {
    _B = value;
  }

  String get A => _A;

  set A(String value) {
    _A = value;
  }

  String get noiDung => _noiDung;

  set noiDung(String value) {
    _noiDung = value;
  }

  String get deBai => _deBai;

  set deBai(String value) {
    _deBai = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}