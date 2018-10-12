part of lss;

class IntLSS {
  String _key;
  int _value;
  get value => _value;
  set value(int v) {
    if (_broken(v)) _setDefault();
    else _writeToLocalStorage(v);
  }

  IntLSS(this._key) {
    try {
      int v = int.parse(window.localStorage[_key]);
      if (_broken(v)) _setDefault();
      else _value = v;
    } catch (e) {
      _setDefault();
    }
    _restore(); // Защита от перезаписи значения LSS в браузере
  }

  void _restore() {
    void _onStorageChange(StorageEvent e) {
      if (e.key == _key) window.localStorage[_key] = _value.toString();
    }
    window.onStorage.listen(_onStorageChange);
    // но! почему-то onStorage не отслеживает изменения setItem()
  }

  /// Запись внутреннего значения и в ls
  void _writeToLocalStorage(int v) {
    _value = v;
    window.localStorage[_key] = v.toString();
  }

  // Изменяемая часть

  void _setDefault() => _writeToLocalStorage(0);

  bool _broken(int v) => false; // нет проверки
}
