part of map_component;

class GlobComponent {
  GlobModel _model;
  Kernel _k;

  GlobComponent() {
    _model = new GlobModel(this);
    new GlobController(_model);
    _k = new Kernel();
  }

  void backHome() => _k.director.backHome();

  void refreshGlob(bool quick) => _k.director.reglob(quick);
}

class GlobView implements DialogManagerEscapeObserver {
  GlobModel _model;
  GlobController _controller;
  DivElement _elGlobBtn;
  DivElement _elGlobCont;
  DivElement _elToHome;
  DivElement _elRefresh;
  DivElement _elClose;
  DialogManager _dialogManager;
  
  GlobView(this._controller, this._model) {
    _dialogManager = new DialogManager();
    _dialogManager.registerObserver(this);
  }

  void createView() {
    // links
    _elGlobBtn = document.querySelector('#glob_btn');
    _elGlobCont = document.querySelector('#glob');
    _elClose = _elGlobCont.querySelector('.close__btn');
    _elToHome = _elGlobCont.querySelector('.toback__btn');
    _elRefresh = _elGlobCont.querySelector('.refresh__btn');
    
    // events
    
    _elGlobBtn.onMouseDown.listen((Event e) => _controller.switchGlob());
    _elGlobBtn.onTouchStart.listen((Event e) {
      e.preventDefault();
      _controller.switchGlob();
    });

    _elClose.onMouseDown.listen((Event e) => _controller.closeGlob());
    _elClose.onTouchStart.listen((Event e) {
      e.preventDefault();
      _controller.closeGlob();
    });

    _elToHome.onMouseDown.listen((Event e) => _controller.backToHome());
    _elToHome.onTouchStart.listen((Event e) {
      e.preventDefault();
      _controller.backToHome();
    });

    _elRefresh.onMouseDown.listen((Event e) => _controller.manualRefresh());
    _elRefresh.onTouchStart.listen((Event e) {
      e.preventDefault();
      _controller.manualRefresh();
    });
  }

  void pressBtn() => _elGlobBtn.classes.add('btn_on');

  void unpressBtn() => _elGlobBtn.classes.remove('btn_on');

  void showGlob() {
    _me();
    _elGlobCont.classes.add('shown');
  }

  void hideGlob() => _elGlobCont.classes.remove('shown');

  // dialog manager

  @override
  void escape() => _controller.closeGlob();

  @override
  bool hasElement(Element el) {
    // return _elGlobCont.contains(el) || _elGlobBtn.contains(el);
    return true;
  }

  void _me() => _dialogManager.me(this);

}

class GlobController {
  GlobModel _model;
  GlobView _view;

  GlobController(this._model) {
    _view = new GlobView(this, _model);
    _view.createView();
    _runView();
  }

  void _runView() {

  }

  void switchGlob() {
    if (_model.shown) {
      // скрываем glob
      closeGlob();
    } else {
      // показываем glob
      _model.shown = true;
      _view.pressBtn();
      _view.showGlob();
    }
  }

  void closeGlob() {
    _model.shown = false;
    _view.unpressBtn();
    _view.hideGlob();
  }

  void backToHome() => _model.backHome();

  void manualRefresh() => _model.manualRefresh();

}

class GlobModel {
  GlobComponent component;
  
  bool _shown;
  bool get shown => _shown;
  set shown(bool v) {
    _shown = v;
    DateTime now = new DateTime.now();
    if (_shown && (_was == null || now.difference(_was).inMilliseconds > 1800)) {
      // т.е. не будем обновлять glob при открытии, если открывали менее 2s назад
      component.refreshGlob(true);
      _was = now;
    }
  }

  DateTime _was;
  
  GlobModel(this.component) {
    shown = false;
  }

  void backHome() => component.backHome();

  void manualRefresh() => component.refreshGlob(false);

}