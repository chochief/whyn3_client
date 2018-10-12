part of settings;

class SettingsController {
  SettingsModel _model;
  SettingsView _view;
  
  SettingsController(this._model) {
    _view = new SettingsView(this, _model);
    _view.createView();
    _runView();
  }

  void _runView() {
    // _view.addWarning();
  }

  void switchSettings() {
    if (_model.opened) {
      // закрываем
      closeDialog();
    } else {
      // открываем
      _model.opened = true;
      _view.openDialog();
    }
  }

  void closeDialog() {
      _model.opened = false;
      _view.closeDialog();
  }

}