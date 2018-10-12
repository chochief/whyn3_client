library finder;

import 'dart:html';
import 'dart:async';
import 'dart:math';

import 'package:WhynClient/kernel/kernel.dart';
import 'package:WhynClient/kernel/config.dart';

class Finder {
  int _timestamp;
  num _accuracy; // точность
  num _speed; // скорость
  num _altitude; // высота
  num _altitudeAccuracy; // точность высоты
  num _heading; // направление
  num _la; 
  num _lo;
  num _laTmp; // временные значения la и lo
  num _loTmp; // проверки на дситанцию смещения
  Geolocation _gl;
  Kernel _k;
  StreamSubscription<Geoposition> _watchPosLister;

  Finder() {
    _gl = window.navigator.geolocation;
    _k = new Kernel();
    _start();
  }

  void _start() {
    // _watchPosLister = _gl.watchPosition(enableHighAccuracy: true, timeout: const Duration(seconds: 3), maximumAge: const Duration(seconds: 0)).listen((Geoposition geoposition)
    _watchPosLister = _gl.watchPosition(enableHighAccuracy: true).listen((Geoposition geoposition) {
      _timestamp = geoposition.timestamp;
      _accuracy = geoposition.coords.accuracy;
      _speed = geoposition.coords.speed;
      _altitude = geoposition.coords.altitude;
      _altitudeAccuracy = geoposition.coords.altitudeAccuracy;
      _heading = geoposition.coords.heading;
      _laTmp = geoposition.coords.latitude;
      _loTmp = geoposition.coords.longitude;
      _sendUpdates();
    });
  }

  void _sendUpdates() {
    if (_movement()) {
      _la = _laTmp;
      _lo = _loTmp;
      _k.director.updateUs(_la, _lo);
    }
  }

  void stop() {
    _watchPosLister.cancel();
    _k = null;
  }

  /// Было ли перемещение (Config.dist метров или больше)
  /// для первого раза считается что было
  bool _movement() {
    if (_la == null || _lo == null) return true;
    return distance([_la, _lo], [_laTmp, _loTmp]) >= Config.dist;
  }

  /// Возвращает дистанцию между точками в метрах
  num distance(List pa, List pb) {
    if (pa.length != 2 || pb.length != 2) return 0;
    num la1 = 0.0000085; // градусов = 1м
    num lo1 = 0.0000170; // градусов = 1м
    num ac = (pa[0]-pb[0])/la1; // АС в метрах
    num bc = (pa[1]-pb[1])/lo1; // BC в метрах
    num ab = sqrt(pow(ac, 2) + pow(bc, 2));
    return ab;
  }

  // static int mega(num v) => (v * 1000000).round();

  // static num mi(int v) => v/1000000;

  @override
  String toString() {
    String string = """
    mla: $_la
    mlo: $_lo
    timestamp: $_timestamp
    accuracy: $_accuracy
    speed $_speed
    heading: $_heading
    altitude: $_altitude
    altitudeAccuracy: $_altitudeAccuracy
    """;
    return string;
  }

}

