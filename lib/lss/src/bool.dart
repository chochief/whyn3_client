part of lss;

class BoolLSS {
  String _key;
  bool _default;
  bool _value;
  get value => _value;
  set value(bool v) {
    _writeToLocalStorage(v);
  }

  BoolLSS(this._key, this._default) {
    try {
      String v = window.localStorage[_key];
      if (v == 'true') _value = true;
      else if (v == 'false') _value = false;
      else _setDefault();
    } catch (e) {
      _setDefault();
    }
    _restore(); // Защита от перезаписи значения LSS в браузере
  }

  void _restore() {
    void _onStorageChange(StorageEvent event) {
      if (event.key == _key) window.localStorage[_key] = _value.toString();
    }
    window.onStorage.listen(_onStorageChange);
  }

  /// Запись внутреннего значения и в ls
  void _writeToLocalStorage(bool v) {
    _value = v;
    window.localStorage[_key] = v.toString();
  }

  void _setDefault() => _writeToLocalStorage(_default);

}
