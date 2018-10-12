part of settings;

class SettingsComponent {
  SettingsComponent _component;
  SettingsModel _model;
  Kernel _k;

  SettingsComponent() {
    _component = this;
    _model = new SettingsModel(_component);
    new SettingsController(_model);
    _k = new Kernel();
  }

  // void notify(int samf) => _k.mailer.sendSettings(samf);
  void notify(int samf) {
    _k.mailer.sendSamfDelay(samf);
  }

  void sendCurrentSamf() {
    _k.mailer.sendSamf(_model.samf);
  }

}