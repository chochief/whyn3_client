part of help;

class HelpController {
  HelpModel _model;
  HelpView _view;
  
  HelpController(this._model) {
    _view = new HelpView(this, _model);
    _view.createView();
    _runView();
  }

  void _runView() {
    if (_model.online == false) _switchOffline();
    else _switchOnline();
  }

  void _switchOnline() {
      _view.removeWarning();
      _view.onlineSwitched();
  }

  void _switchOffline() {
      _view.addWarning();
      _view.offlineSwitched();
  }

  void switchSettings() {
    if (_model.opened) {
      // закрываем
      closeDialog();
    } else {
      // открываем
      _model.opened = true;
      _view.openDialog();
      stats();
    }
  }

  void write(int stats) {
    _view.writeStats(stats.toString());
    _view.statsBtnWrite('обновить');
  }

  void stats() {
    _model.stats();
    _view.writeStats('...');
    _view.statsBtnWrite('загрузка');
  }

  void closeDialog() {
      _model.opened = false;
      _view.closeDialog();
  }

  void setOnline() {
    if (_model.online) return; // ! надо
    _model.setOnline(); // _model.online = true;
    _switchOnline();
    new Timer(const Duration(seconds: 1), () => closeDialog());
  }

  void setOffline() {
    if (_model.online == false) return; // ! надо
    _model.setOfline(); // _model.online = false;
    _switchOffline();
    new Timer(const Duration(seconds: 1), () => closeDialog());
  }

}