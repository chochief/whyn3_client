library switcher;

import 'dart:html';
import 'dart:async';

import 'package:WhynClient/kernel/kernel.dart';
import 'package:WhynClient/kernel/config.dart';

class Switcher {
  static Switcher _switcher = new Switcher._internal();
  Kernel _k;
  
  factory Switcher() => _switcher;

  Switcher._internal() {
    _k = new Kernel();
    _looper();
  }

  void _looper() {
    bool page;
    bool turnOn;

    new Timer.periodic(Config.switcher, (Timer timer) {
      page = document.hidden == false ? true : false;
      turnOn = _k.helpComponent.isOnline();

      if (page && turnOn) {
        // вкладка активна и переключатель Gps на Help включен
        _k.mailer.start();
      } else {
        // вкладка не активна
        _k.mailer.stop();
      }

      // Finder вынесен в Mailer, т.к. это удобнее
      // Mailer при открытии создает новый Finder и ждет данные.
      // При закрытии сокета Mailer удаляет Finder.
      // Google Chrome к примеру данные отдает мнгновенно,
      // т.о. Mailer всегда будет готов, а задержка минимальна зачастую.
    });

  }
}
