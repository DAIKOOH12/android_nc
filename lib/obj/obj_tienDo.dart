class obj_tienDo {
  double _tuVung;
  double _nghe;
  double _nguPhap;
  double _percent;

  obj_tienDo(this._tuVung, this._nghe, this._nguPhap, this._percent);

  double get percent => _percent;

  set percent(double value) {
    _percent = value;
  }

  double get nguPhap => _nguPhap;

  set nguPhap(double value) {
    _nguPhap = value;
  }

  double get nghe => _nghe;

  set nghe(double value) {
    _nghe = value;
  }

  double get tuVung => _tuVung;

  set tuVung(double value) {
    _tuVung = value;
  }
}