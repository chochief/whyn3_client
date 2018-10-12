part of map_component;

abstract class Onlineable {
  void setOnline();
  void setOfline();
}

class OnlineableMock implements Onlineable {
  @override
  void setOfline() => print('OnlineableMock: called setOfline()');

  @override
  void setOnline() => print('OnlineableMock: called setOnline()');
}

class OnlineComponent {
  Onlineable _onlineable;
  
  OnlineModel _onlineModel;
  OnlineView _onlineView;

  OnlineComponent(this._onlineable) {
    _onlineModel = new OnlineModel(_onlineable);
    new OnlineController(_onlineModel);
    // _onlineModel.lat = 57.633127;
    // _onlineModel.lon = 39.831698;
  }
}

class OnlineView {
  OnlineModel _onlineModel;
  OnlineController _onlineController;
  DivElement _elOnlineBtn;
  DivElement _elSimsAlert;

  OnlineView(this._onlineController, this._onlineModel);

  void createView() {
    // ссылки
    _elOnlineBtn = document.querySelector('#btns_online');
    _elSimsAlert = document.querySelector('#sims_alert');

    document.querySelector('.loading').classes.add('hidden');

    // обработчики
    _elOnlineBtn.onClick.listen((Event e) => _onlineController.switchOnline());

  }

  void setOnlineBtn(String state) {
    if (state == 'lock') _elOnlineBtn.classes.add('btn_off');
    else if (state == 'unlock') _elOnlineBtn.classes.remove('btn_off');
    else if (state == 'on') _elOnlineBtn.classes.add('btn_on');
    else if (state == 'off') _elOnlineBtn.classes.remove('btn_on');
  }

  void showSimsAlert() => _elSimsAlert.classes.add('on');
  
  void hideSimsAlert() => _elSimsAlert.classes.remove('on');

  void setSimsAlert(String text) => _elSimsAlert.innerHtml = text; 

}

class OnlineController {
  OnlineModel _onlineModel;
  OnlineView _onlineView;

  OnlineController(this._onlineModel) {
    _onlineView = new OnlineView(this, _onlineModel);
    _onlineView.createView();
    _runView();
  }

  void _runView() {
    _onlineView.setOnlineBtn('unlock');
    _onlineView.showSimsAlert();
    if (_onlineModel.online) _drawOnline();
    else _drawOfline();
  }

  void switchOnline() {
    if (_onlineModel._online) {
      // выход в офлайн
      _onlineModel.setOfline();
      _drawOfline();
    } else {
      // вход в онлайн
      _onlineModel.setOnline();
      _drawOnline();
    }
  }

  void _drawOnline() {
    _onlineView.setOnlineBtn('on');
    _onlineView.setSimsAlert('онлайн / люди');
  }

  void _drawOfline() {
    _onlineView.setOnlineBtn('off');
    _onlineView.setSimsAlert('офлайн / боты');
  }

}

class OnlineModel {
  Onlineable component;

  num _lat;
  get lat => _lat;
  set lat(num v) {
    _lssLat.value = v;
    _lat = _lssLat.value;
  }
  LatLSS _lssLat;

  num _lon;
  get lon => _lon;
  set lon(num v) {
    _lssLon.value = v;
    _lon = _lssLon.value;
  }
  LonLSS _lssLon;

  bool _online;
  get online => _online;
  set online(bool v) {
    _lssOnline.value = v;
    _online = _lssOnline.value;
  }
  BoolLSS _lssOnline;

  OnlineModel(this.component) {
    _lssLat = new LatLSS('map:lat');
    _lssLon = new LonLSS('map:lon');
    _lssOnline = new BoolLSS('map:online', false);
    _loadingChecks();
  }

  void _loadingChecks() {
    _lat = _lssLat.value;
    _lon = _lssLon.value;
    if (_lat == null || _lon == null) online = false;
    else _online = _lssOnline.value;
  }

  void setOnline() {
    if (online) return; 
    online = true;
    component.setOnline();
  }

  void setOfline() {
    if (online == false) return;
    online = false;
    component.setOfline();
  }

}