part of lss;

class StrLSS {
  String _key;
  String _value;
  get value => _value;
  set value(String v) {
    if (_broken(v)) _setDefault();
    else _writeToLocalStorage(v);
  }

  StrLSS(this._key) {
    try {
      String v = window.localStorage[_key];
      if (_broken(v)) _setDefault();
      else _value = v;
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
  void _writeToLocalStorage(String v) {
    _value = v;
    window.localStorage[_key] = v;
  }

  // Изменяемая часть

  void _setDefault() => _writeToLocalStorage('-');

  bool _broken(String v) => v == null || v.isEmpty;
}
