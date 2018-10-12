part of lss;

class CountLSS extends IntLSS {
  CountLSS(String key) : super(key);

  bool _broken(int v) => v < 0;
}

class HashLSS extends IntLSS {
  HashLSS(String key) : super(key) {
    // почему-то window.onStorage не отслеживает изменения setItem()
    // поэтому hash по таймеру защищаем:
    new Timer.periodic(const Duration(milliseconds: 10), (Timer t) {
      if (window.localStorage.containsKey(_key) == false 
      || window.localStorage[_key] != _value.toString()) {
        // print('${_key} restored!'); !!! не переписываем ничего каждые 50 millsec
        window.localStorage[_key] = _value.toString(); 
        // т.е. просто восстанавливаем запись в localStorage если с ней проблемы
      }
    });
  }

  bool _broken(int v) => v < 0;
}

class ZoomLSS extends IntLSS {
  ZoomLSS(String key) : super(key);
  
  // bool _broken(int v) => v < 15 || v > 19;
  bool _broken(int v) => v < 16 || v > 18;
  
  void _setDefault() => _writeToLocalStorage(16);
}

class SamfLSS extends IntLSS {
  SamfLSS(key) : super(key);
  bool _broken(int v) => v < 0;
  void _setDefault() => _writeToLocalStorage(9);
  void reset() => _setDefault();
}