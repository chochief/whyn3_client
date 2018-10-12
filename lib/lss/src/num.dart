part of lss;

class NumLSS {
  String _key;
  num _value;
  get value => _value;
  set value(num v) {
    if (_broken(v)) _setDefault();
    else _writeToLocalStorage(v);
  }

  NumLSS(this._key) {
    try {
      num v = num.parse(window.localStorage[_key]);
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
  void _writeToLocalStorage(num v) {
    _value = v;
    window.localStorage[_key] = v.toString();
  }

  // Изменяемая часть

  void _setDefault() => _writeToLocalStorage(0);

  bool _broken(num v) => false; // нет проверки
}
