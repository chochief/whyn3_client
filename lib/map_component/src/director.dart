part of map_component;

class Director {
  Courier _courier;
  Kernel _k;
  num _la;
  num _lo;
  Map _gpsdata = {};

  // соотношение градусов и метров
  final num la1 = 0.0000085; // градусов = 1м
  final num lo1 = 0.0000170; // градусов = 1м

  // установка карт map и glob после перезагрузки страницы
  bool _initialized; 
  get initialized => _initialized;
  set initialized(bool v) {
    if (_initialized) return;
    _initialized = true;
    _k.mapContainer.enable();
  }

  Director() {
    _courier = new Courier(this);
    _k = new Kernel();
    _initialized = false;
  }

  /// for courier - to handle msg from map.js
  void route(Map data) {
    if (data == null || data['type'] == null || data['type'] != 'js2dart') return;
    else if (data['code'] == 'MAP_READY') _initMaps();
    else if (data['code'] == 'MAP_BOUNDS') _sendGps(data['payload']);
    else if (data['code'] == 'GLOB_GET') _sendGlob(data['payload'], true);
    else if (data['code'] == 'GLOB_BOUNDS') _sendGlob(data['payload'], false);
 
  }

  // protected

  // Это срабатывает после READY от карты
  void _initMaps() {
    if (_k.helpComponent.isOnline()) return; 
    _courier.dart2js('INIT_MAPS_OFFLINE', {
        'zoom': _k.zoomComponent.zoom(),
    });
    initialized = true;
  }

  // Это запускается после получения GPS
  // учитывается, что может измениться isOnline (хотя это излишне уже)
  void _initialize() {
    if (initialized) return;
    if (_k.helpComponent.isOnline())
      _courier.dart2js('INIT_MAPS_ONLINE', {
        'lat': _la,
        'lon': _lo,
        'zoom': _k.zoomComponent.zoom(),
      });
    else
    _courier.dart2js('INIT_MAPS_OFFLINE', {
        'zoom': _k.zoomComponent.zoom(),
    });
    initialized = true;
  }

  void _sendGps(List b) {
    if (_la != null && _lo != null && b != null)
      _gpsdata = {
        'mla': mega(_la), 
        'mlo': mega(_lo),
        'code': radiusCode(radiusIF(b[0], b[1])),
      };
    else return;
    if (_k.helpComponent.isOnline()) sendCurrentGps();
  }

  void _sendGlob(List b, bool quick) {
    int tamla, tamlo, tcmla, tcmlo;
    Map bounds;
    try {
      tamla = mega(b[0][0]);
      tamlo = mega(b[0][1]);
      tcmla = mega(b[1][0]);
      tcmlo = mega(b[1][1]);
    } catch (e) {
      return;
    }
    if (_validMLGps(tamla, tamlo) && _validMLGps(tcmla, tcmlo)) {
      bounds = {
        'tamla': tamla,
        'tamlo': tamlo,
        'tcmla': tcmla,
        'tcmlo': tcmlo,
      };
      if (quick) _k.mailer.sendGlob(bounds);
      else _k.mailer.sendGlobDelay(bounds);
    }
  }

  // public

  void updateUs(num lat, num lon) {
    // для finder (drawMe())
    // ждем обновления bounds после этого
    _la = lat;
    _lo = lon;
    if (initialized) 
      _courier.dart2js('UPDATE_US', {
        'lat': _la,
        'lon': _lo,
      });
    else _initialize();
  }

  /// Очистить карту от точек (при смене reghash)
  void clearMaps() {
    _courier.dart2js('CLEAR_MAPS', {});
  }

  void setOffline() => _courier.dart2js('SET_OFFLINE', {});

  void setOnline() => _courier.dart2js('SET_ONLINE', {});
  // чистим samples и ждем updateUs (switcher запустит mailer/finder)

  void setZoom(int v) => _courier.dart2js('SET_ZOOM', {'value': v});

  void backHome() => _courier.dart2js('BACK_HOME', {});

  /// Получить bounds glob для обновления точек
  void reglob(bool quick) {
    if (_k.helpComponent.isOnline()) _courier.dart2js('REGLOB', {'quick': quick});
    else setOffline();
  }

  /// codes 38, 30
  void move(String to, int h, int mla, int mlo, int mark) {
    if (['m', 'g'].indexOf(to) == -1) return;
    if (_validMLGps(mla, mlo)) {
      num la = micro(mla);
      num lo = micro(mlo);
      _courier.dart2js('MOVE', {
        'to': to,
        'h': h,
        'la': la,
        'lo': lo,
        'm': mark,
        's': Mapco.sector(la, lo),
      });
    }
  }

  /// code 39
  void offline(int h) {
    _courier.dart2js('OFFLINE', {
      'h': h,
    });
  }

  /// code 32
  void remove(int h) {
    _courier.dart2js('REMOVE', {
      'h': h,
    });
  }

  /// code 37
  void recount() {
    if (_la == null || _lo == null) return;
    Set sectorsSet = Mapco.sectors(mega(_la), mega(_lo));
    List sectors = [];
    sectorsSet.forEach((el) {
      sectors.add(el);
    });
    _courier.dart2js('RECOUNT', {
      'sectors': sectors,
    });
  }

  // public for mailer

  /// Отправить текущие координаты и экраны
  void sendCurrentGps() {
    if (_validGpsData()) _k.mailer.sendGPS(_gpsdata);
  }

  //

  bool _validMLGps(int mla, int mlo) {
    int lam = 90000000; // max la
    int lom = 180000000; // max lo
    return 
      mla != null && mla < lam && mla > -(lam) &&
      mlo != null && mlo < lom && mlo > -(lom);
  }

  bool _validGpsData() {
    int lam = 90000000; // max la
    int lom = 180000000; // max lo
    return 
      _gpsdata['mla'] != null && _gpsdata['mla'] < lam && _gpsdata['mla'] > -(lam) &&
      _gpsdata['mlo'] != null && _gpsdata['mlo'] < lom && _gpsdata['mlo'] > -(lom) &&
      _gpsdata['code'] >= 20 && _gpsdata['code'] <= 24 ;
  }

  int mega(num v) => (v * 1000000).round();

  num micro(int v) => v/1000000;

  /// Радиус квадрата, т.е. длина IF
  num radiusIF(List tC, List tA) {
    if (tC == null || tA == null) return 0;
    else return ((tC[0] - tA[0]).abs())/(2*la1);
  }

  /// 
  int radiusCode(num radiusIF) {
    int code;
    if (radiusIF <= 100) code = Codes.gpsdata100; // 20
    else if (radiusIF <= 300) code = Codes.gpsdata300; // 21
    else if (radiusIF <=500) code = Codes.gpsdata500; // 22
    else if (radiusIF <= 700) code = Codes.gpsdata700; // 23
    else code = Codes.gpsdata7pl; // 24
    return code;
  }

}