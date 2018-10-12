part of settings;

class SettingsView implements DialogManagerEscapeObserver {
  SettingsModel _model;
  SettingsController _controller;
  DialogManager _dialogManager;
  DivElement _elSettingsBtn;
  DivElement _elDialog;
  
  SettingsView(this._controller, this._model) {
    _dialogManager = new DialogManager();
    _dialogManager.registerObserver(this);
  }

  void createView() {
    // links
    _elSettingsBtn = document.querySelector('#btns_settings');
    _elDialog = document.querySelector('#settings');

    // events

    _elSettingsBtn.onMouseDown.listen((MouseEvent e) => _controller.switchSettings());
    _elSettingsBtn.onTouchStart.listen((Event e) {
      e.preventDefault();
      _controller.switchSettings();
    });

    _elDialog.querySelectorAll('.sett__btn').forEach((Element el) {
      el.onMouseDown.listen((Event e) => _onKeyClick(e));
      el.onTouchStart.listen((Event e) {
        e.preventDefault();
        _onKeyClick(e);
      });
    });

    _pressing();
  }

  void _onKeyClick(Event e) {
    Element el = e.target;
    String keyCode = _searchInDatasets(el);
    if (keyCode == null) return;
    _model.pressIt(keyCode);
    _pressing();

  }

  String _searchInDatasets(Element el) {
    String keyCode;
    if (el.dataset.containsKey('sex')) keyCode = el.dataset['sex'];
    else if (el.dataset.containsKey('age')) keyCode = el.dataset['age'];
    else if (el.dataset.containsKey('filter')) keyCode = el.dataset['filter'];
    return keyCode;
  }

  void _pressing() {
    _pressingJob('sett__sex-data', 'sex');
    _pressingJob('sett__age-data', 'age');
    _pressingJob('sett__filter_m', 'filter');
    _pressingJob('sett__filter_f', 'filter');

    if (_model.iswarn()) addWarning();
    else removeWarning();
  }

  void _pressingJob(String cls, String dts) {
    _elDialog.querySelectorAll('.${cls} .sett__btn').forEach((Element el) {
      String dtsv = el.dataset['$dts'];
      if (dtsv != null && se[dtsv] != null && _model.pressed(se[dtsv])) 
        el.classes.add('btn_on');
      else el.classes.remove('btn_on');
    });
  }

  void addWarning() => _elSettingsBtn.classes.add('btn_warn');

  void removeWarning() => _elSettingsBtn.classes.remove('btn_warn');

  void openDialog() {
    _elDialog.classes.add('on');
    _elSettingsBtn.classes.add('btn_on');
    _me();
  }

  void closeDialog() {
    _elDialog.classes.remove('on');
    _elSettingsBtn.classes.remove('btn_on');
  }

  @override
  void escape() {
    _controller.closeDialog();
  }

  @override
  bool hasElement(Element el) {
    return _elDialog.contains(el) || _elSettingsBtn.contains(el);
  }

  void _me() => _dialogManager.me(this);

}