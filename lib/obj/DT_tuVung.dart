class DT_tuVung {
  late String _tu;
  late String _nghia;
  late String _maChuDe;
  late String _tenChuDe;


  DT_tuVung(this._tu, this._nghia, this._maChuDe, this._tenChuDe);




  String get nghia => _nghia;

  set nghia(String value) {
    _nghia = value;
  }

  String get tu => _tu;

  set tu(String value) {
    _tu = value;
  }

  String get tenChuDe => _tenChuDe;

  set tenChuDe(String value) {
    _tenChuDe = value;
  }

  String get maChuDe => _maChuDe;

  set maChuDe(String value) {
    _maChuDe = value;
  }
}