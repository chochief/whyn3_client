part of lss;

class LatLSS extends NumLSS {
  LatLSS(String key) : super(key);

  bool _broken(num v) => v <= -90 || v >= 90;
  
  void _setDefault() => _writeToLocalStorage(null);
}

class LonLSS extends NumLSS {
  LonLSS(String key) : super(key);

  bool _broken(num v) => v < -180 || v > 180;
  
  void _setDefault() => _writeToLocalStorage(null);
}
