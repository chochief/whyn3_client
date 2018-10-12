library dialog_manager;

/// Позволяет управлять диалоговыми окнами как в ОС
/// т.е. 1) переводить на передний план по клику
/// 2) убирать по esc

import 'dart:html';

abstract class DialogManagerEscapeObserver {
  void escape();
  bool hasElement(Element el);
}

class DialogManager {
  static DialogManager _dialogManager = new DialogManager._internal();
  int _index;

  factory DialogManager() => _dialogManager;

  // внутренний конструктор
  DialogManager._internal() {
    _index = 21000;
    // Escape Event
    document.onKeyDown.listen((KeyboardEvent e) {
      if (e.keyCode == 27) _notifyDMObservers();
    });
    // touch handler
    void _emptyClickOrTouch(Event e) {
      Element el = e.target;
      if (_dmObservers.contains(el) == false) {
        bool found = false;
        for (var i = 0; i < _dmObservers.length; i++) {
          if (_dmObservers[i].hasElement(el)) {
            found = true;
            break;
          }
        }
        if (found == false) _notifyDMObservers();
      }
    }
    document.onClick.listen(_emptyClickOrTouch);
  }

  int up(int dialogIndex) {
    if (dialogIndex != _index) _index++;
    return _index;
  }

  void me(DialogManagerEscapeObserver m) {
    _notifyOthersObservers(m);
  }

  // DialogManagerEscape Observable
  List<DialogManagerEscapeObserver> _dmObservers = new List<DialogManagerEscapeObserver>();

  void registerObserver(DialogManagerEscapeObserver o) {
    _dmObservers.add(o);
  }

  void _notifyDMObservers() {
    for (var i = 0; i < _dmObservers.length; i++) {
      _dmObservers[i].escape();
    }
  }

  void _notifyOthersObservers(DialogManagerEscapeObserver me) {
    for (var i = 0; i < _dmObservers.length; i++) {
      if (_dmObservers[i] != me) _dmObservers[i].escape();
    }
  }

}