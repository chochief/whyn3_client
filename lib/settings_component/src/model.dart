part of settings;

class SettingsModel {
  SettingsComponent _component;
  bool opened;

  SamfLSS _lssSamf;
  int _samf;
  get samf => _samf;

  SettingsModel(this._component) {
    opened = false;
    _lssSamf = new SamfLSS('samf');
    _samf = _lssSamf.value;
    _checkSamf();
  }

  bool pressed(int i) {
    if (i == null) return false;
    return (_samf & i) != 0;
  }

  bool iswarn() {
    bool sok = (_samf & (sm | sf)) != 0;
    bool aok = (_samf & (aa | ab | ac | ad | ae | af)) != 0;
    bool mok = (_samf & (ma | mb | mc | md | me | mf)) != 0;
    bool fok = (_samf & (fa | fb | fc | fd | fe | ff)) != 0;
    bool nok = (_samf & (sn | an)) == 0;
    bool zok = _samf != 0;
    return !(sok && aok && (mok || fok) && nok && zok);
  }

  void _checkSamf() {
    _checkSex();
    _checkAge();
    _checkFilter();
  }

  void _checkSex() {
    int count = 0;
    if (pressed(sn)) count++;
    if (pressed(sm)) count++;
    if (pressed(sf)) count++;
    if (count != 1) _setDefault();
  }

  void _setDefault() {
    _lssSamf.reset();
    _samf = _lssSamf.value;
  }

  void _checkAge() {
    int count = 0;
    if (pressed(an)) count++;
    if (pressed(aa)) count++;
    if (pressed(ab)) count++;
    if (pressed(ac)) count++;
    if (pressed(ad)) count++;
    if (pressed(ae)) count++;
    if (pressed(af)) count++;
    if (count != 1) _setDefault();
  }

  void _checkFilter() {
    int count = 0;
    if (pressed(ma)) count++;
    if (pressed(mb)) count++;
    if (pressed(mc)) count++;
    if (pressed(md)) count++;
    if (pressed(me)) count++;
    if (pressed(mf)) count++;
    if (pressed(fa)) count++;
    if (pressed(fb)) count++;
    if (pressed(fc)) count++;
    if (pressed(fd)) count++;
    if (pressed(fe)) count++;
    if (pressed(ff)) count++;
    if (count == 12) {
      _lssSamf.value = (_samf^ma^mb^mc^md^me^mf^fa^fb^fc^fd^fe^ff);
      _samf = _lssSamf.value;

    }
  }

  /// Пересчитать samf по коду нажатой кнопки
  /// и поменять его, если он в результате изменился
  void pressIt(String code) {
    if (se[code] == null) return;
    int tsamf = _samf;
    if ([sn, sm, sf].contains(se[code])) {
      // отжимеам все кнопки sex
      tsamf = _unpressIt(tsamf, sn);
      tsamf = _unpressIt(tsamf, sm);
      tsamf = _unpressIt(tsamf, sf);
    }
    if ([an, aa, ab, ac, ad, ae, af].contains(se[code])) {
      // отжимаем все кнопки age
      tsamf = _unpressIt(tsamf, an);
      tsamf = _unpressIt(tsamf, aa);
      tsamf = _unpressIt(tsamf, ab);
      tsamf = _unpressIt(tsamf, ac);
      tsamf = _unpressIt(tsamf, ad);
      tsamf = _unpressIt(tsamf, ae);
      tsamf = _unpressIt(tsamf, af);
    }
    tsamf = tsamf^se[code]; // получаем новое значение
    // if (tsamf != _samf) {
    // если samf изменился в результате
    _lssSamf.value = tsamf;
    _samf = _lssSamf.value;
    _checkSamf();
    _component.notify(_samf);
    // }
  }

  int _unpressIt(int t, int i) {
    if (pressed(i)) return t ^ i;
    else return t;
  }

  /// Извлекает s и a из samf
  String safromSamf() {
    String s = decode(sn);
    String a = decode(an);
    String sa = 'n';
    for (var i = 0; i < ses.length; i++) {
      if (pressed(ses[i])) {
        s = decode(ses[i]);
        break;
      }
    }
    for (var i = 0; i < sea.length; i++) {
      if (pressed(sea[i])) {
        a = decode(sea[i]);
        break;
      }
    }
    if (s == 'n' || a == 'n') sa = 'n';
    else sa = '$s$a';
    return sa;
  }

  /// Извлекает все f из samf
  List<String> mfFromSamf() {
    List<String> f = [];
    for (var i = 0; i < sem.length; i++) {
      if (pressed(sem[i])) f.add(decode(sem[i]));
    }
    for (var i = 0; i < sef.length; i++) {
      if (pressed(sef[i])) f.add(decode(sef[i]));
    }
    return f;
  }

  String decode(int digit) => es[digit];

  List<String> chats() {
    String sa = safromSamf();
    List<String> chs = [];
    if (sa == 'n') return chs;
    List<String> filters = mfFromSamf();
    filters.forEach((String f) {
      chs.add('$sa$f');
    });
    return chs;
  }

  String mirror(String chat) {
    if (chat.length != 4) return '';
    return '${chat.substring(2)}${chat.substring(0, 2)}';
  }

  List<String> underchats(List<String> chs) {
    List<String> uchs = [];
    chs.forEach((String chat) {
      uchs.add(mirror(chat));
    });
    return uchs;
  }

}