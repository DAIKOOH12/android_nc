class obj_luyenNghe {
  late String _id, _maBTL, _link, _cauHoi, _tieuDe, _A, _B, _C, _D, _dapAn;

  obj_luyenNghe(this._id, this._maBTL, this._link, this._cauHoi, this._tieuDe, this._A, this._B, this._C, this._D, this._dapAn);

  get dapAn => _dapAn;

  set dapAn(value) {
    _dapAn = value;
  }

  get A => _A;

  set A(value) {
    _A = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  get tieuDe => _tieuDe;

  set tieuDe(value) {
    _tieuDe = value;
  }

  get cauHoi => _cauHoi;

  set cauHoi(value) {
    _cauHoi = value;
  }

  get link => _link;

  set link(value) {
    _link = value;
  }

  String get maBTL => _maBTL;

  set maBTL(String value) {
    _maBTL = value;
  }

  get B => _B;

  set B(value) {
    _B = value;
  }

  get C => _C;

  set C(value) {
    _C = value;
  }

  get D => _D;

  set D(value) {
    _D = value;
  }
}