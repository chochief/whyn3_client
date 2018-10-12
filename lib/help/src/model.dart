part of help;

class HelpModel {
  HelpComponent component;

  bool _online;
  get online => _online;
  set online(bool v) {
    _lssOnline.value = v;
    _online = _lssOnline.value;
  }
  BoolLSS _lssOnline;  

  bool opened;

  HelpModel(this.component) {
    opened = false;
    _lssOnline = new BoolLSS('help:online', false);
    _online = _lssOnline.value;
  }

  void setOnline() {
    if (online) return; 
    online = true;
    component.switchedOnline();
  }

  void setOfline() {
    if (online == false) return;
    online = false;
    component.switchedOffline();
  }

  void stats() => component.stats();

}