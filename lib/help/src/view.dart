part of help;

class HelpView implements DialogManagerEscapeObserver {
  HelpModel _model;
  HelpController _controller;
  DialogManager _dialogManager;
  DivElement _elHelpBtn;
  DivElement _elHelpDlg;
  DivElement _elOnlineBtn;
  DivElement _elOfflineBtn;
  DivElement _elStats;
  DivElement _elStatsBtn;
  
  HelpView(this._controller, this._model) {
    _dialogManager = new DialogManager();
    _dialogManager.registerObserver(this);
  }

  void createView() {
    // links
    _elHelpBtn = document.querySelector('#btns_help');
    _elHelpDlg = document.querySelector('#help_dlg');
    _elOnlineBtn = document.querySelector('#online_btn');
    _elOfflineBtn = document.querySelector('#offline_btn');
    _elStats = document.querySelector('#online_stats');
    _elStatsBtn = document.querySelector('#stats_btn');

    // events

    _elHelpBtn.onMouseDown.listen((MouseEvent e) => _controller.switchSettings());
    _elHelpBtn.onTouchStart.listen((Event e) {
      e.preventDefault();
      _controller.switchSettings();
    });
    
    _elOnlineBtn.onClick.listen((Event e) => _controller.setOnline());

    _elOfflineBtn.onClick.listen((Event e) => _controller.setOffline());

    _elStatsBtn.onClick.listen((Event e) => _controller.stats());
  }

  void writeStats(String v) => _elStats.innerHtml = '$v';

  void statsBtnWrite(String v) => _elStatsBtn.innerHtml = '$v';
  
  void addWarning() => _elHelpBtn.classes.add('btn_warn');

  void removeWarning() => _elHelpBtn.classes.remove('btn_warn');

  void openDialog() {
    writeStats('_');
    _elHelpDlg.classes.add('on');
    _elHelpBtn.classes.add('btn_on');
    _me();
  }

  void closeDialog() {
    _elHelpDlg.classes.remove('on');
    _elHelpBtn.classes.remove('btn_on');
  }

  void onlineSwitched() {
    _elOnlineBtn.classes.add('btn_off');
    _elOnlineBtn.classes.remove('warn_btn');
    _elOfflineBtn.classes.remove('btn_off');
  }

  void offlineSwitched() {
    _elOnlineBtn.classes.remove('btn_off');
    _elOnlineBtn.classes.add('warn_btn');
    _elOfflineBtn.classes.add('btn_off');
  }

  @override
  void escape() => _controller.closeDialog();

  @override
  bool hasElement(Element el) {
    return _elHelpDlg.contains(el) || _elHelpBtn.contains(el);
  }

  void _me() => _dialogManager.me(this);

}