library mapco;

import 'dart:math';

/// Map computes
 
class Mapco {
  // соотношение градусов и метров
  static const num la1 = 0.0000085; // градусов = 1м
  static const num lo1 = 0.0000170; // градусов = 1м

  // sector sides (отрезки в градусах)
  static const num las = 0.005;  // lat 0.005 ~588m
  static const num los = 0.010; // lon 0.010 ~588m

  // square Iam (отрезки в градусах)
  static const num laq = las;
  static const num loq = los;

  // пределы mla mlo
  static const int mlamax = 90000000; // max la
  static const int mlomax = 180000000; // max lo


  /// Получить секторы (для подписки)
  /// по точке gps (mla, mlo)
  static Set sectors(int mla, int mlo) {
    Set s = new Set();
    //
    num la = micro(mla);
    num lo = micro(mlo);
    num lam = la - laq;
    num lap = la + laq;
    num lom = lo - loq;
    num lop = lo + loq;

    // 8 points
    Map points = {};
    points[1] = [lam, lom]; // tA
    points[8] = [lam, lo]; // tH 
    points[5] = [la, lom]; // tE
    points[2] = [lap, lom]; // tB
    points[6] = [lap, lo]; // tF
    points[3] = [lap, lop]; // tC
    points[7] = [la, lop]; // tG
    points[4] = [lam, lop]; // tD

    for (var i = 1; i <= 8; i++) {
      // print('$i: ${points[i]}');
      s.add(sector(points[i][0], points[i][1]));
    }

    return s;
  }

  /// Получение сектора точки по её координатам
  /// т.е. точку Y (max, max) для данных констант las и los
  static String sector(num lat, num lon) {
    int lonPart = sectorsLonPart(lon);
    int latPart = sectorsLatPart(lat);
    return '$latPart|$lonPart';
  }

  /// Получить latPart ключа сектора
  static int sectorsLatPart(num la) {
    int latPart;
    num lat100 = la*100;
    int latCeil = lat100.ceil();
    int latRound = lat100.round();
    // if (latCeil == latRound) latPart = '${latCeil.toString()}0';
    // else latPart = '${latRound.toString()}5';
    // return int.parse(latPart);
    if (latCeil == latRound) latPart = latCeil*10;
    else latPart = latRound*10+5; // '${latRound.toString()}5';
    // ? для отрицательных lat должно нормально работать 
    // т.е. тот же принцип Y (правая верхняя точка)
    return latPart;
  }

  /// Получить lonPart ключа сектора
  static int sectorsLonPart(num lo) => (lo*100).ceil();

  /// Получить секторы экрана
  static Set screenSectors(List tA, List tC) {
    Set sects = new Set();

    // checks
    if ((tA[0] > tC[0]) || (tA[1] > tC[1])) return sects;
    
    // lons
    Set losSet = new Set();
    int losC = sectorsLonPart(tC[1]); // lo крайнего справа сектора C
    int losA = sectorsLonPart(tA[1]); // lo крайнего слева сектора A
    int computedSectLon = losA;
    while (computedSectLon <= losC) {
      losSet.add(computedSectLon);
      computedSectLon += 1; // прибавляем по одному сектору
    }
    // print('losSet: $losSet');

    // lats
    Set lasSet = new Set();
    int lasC = sectorsLatPart(tC[0]); // la крайнего сверху сектора C
    int lasA = sectorsLatPart(tA[0]); // la крайнего снизу сектора A
    int computedSectLat = lasA;
    while (computedSectLat <= lasC) {
      lasSet.add(computedSectLat);
      computedSectLat += 5; // прибавляем по одному секторы (у lat шаг 5)
    }
    // print('lasSet: $lasSet');

    lasSet.forEach((e1) {
      losSet.forEach((e2) {
        sects.add('${e1}|${e2}');
      });
    });
    // print('sects: $sects');

    return sects;
  }

  // common

  /// Возвращает дистанцию между точками в метрах
  static num distance(List pa, List pb) {
    if (pa.length != 2 || pb.length != 2) return 0;
    num ac = (pa[0]-pb[0])/la1; // АС в метрах
    num bc = (pa[1]-pb[1])/lo1; // BC в метрах
    num ab = sqrt(pow(ac, 2) + pow(bc, 2));
    return ab;
  }

  /// Взять градусы, вернуть целое число
  static int mega(num v) => (v * 1000000).round();

  /// Взять целое число (представление градусов)
  /// вернуть градусы
  static num micro(int v) => v/1000000;

  static bool validate(dynamic mla, dynamic mlo) {
    bool valid = false;
    if (mla is int && mlo is int) { // if null -> false
      if (mla < mlamax && mla > -(mlamax)
          && mlo < mlomax && mlo > -(mlomax)) valid = true;
    }
    return valid;
  }

}