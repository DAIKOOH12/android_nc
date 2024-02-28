class obj_CacBaiNguPhap {
  String _id;
  String _link;
  String _tenChuDe;

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get link => _link;

  String get tenChuDe => _tenChuDe;

  obj_CacBaiNguPhap(this._id, this._link, this._tenChuDe);

  set tenChuDe(String value) {
    _tenChuDe = value;
  }

  set link(String value) {
    _link = value;
  }
}