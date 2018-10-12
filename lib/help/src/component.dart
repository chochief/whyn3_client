part of help;

class HelpComponent {
  // Helpable
  HelpModel _model;
  HelpController _controller;
  Kernel _k;

  HelpComponent() {
    _k = new Kernel();
    _model = new HelpModel(this);
    _controller = new HelpController(_model);
  }

  bool isOnline() => _model.online;

  void switchedOnline() => _k.director.setOnline();

  void switchedOffline() => _k.director.setOffline();

  void stats() => _k.mailer.statsDelay();

  void write(int stats) => _controller.write(stats);
  
}