library browser;

import 'dart:html';

class Browser {

  Browser();

  bool unsupported() {
    if (window == null) return true;
    if (window.navigator == null) return true;
    if (window.navigator.geolocation == null) return true;
    if (window.navigator.storage == null) return true;
    if (window.navigator.onLine == null) return true;
    // if (window.navigator.userAgent.contains('mozilla')) return true;
    // print(window.navigator.userAgent);
    return false;
  }

  bool internet() => window.navigator.onLine;
  
}