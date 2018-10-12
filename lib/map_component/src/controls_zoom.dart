part of map_component;

// abstract class Zoomable {
//   void setZoom(int v);
//   // void zoomPlus();
//   // void zoomMinus();
//   // void maxZoom();
//   // void minZoom();
// }

// class ZoomableMock implements Zoomable {
//   @override
//   void setZoom(int v) => print('ZoomableMock: setZoom to $v');
// }

class ZoomComponent {
  Kernel _kernel;
  ZoomModel _zoomModel;

  ZoomComponent() {
    _kernel = new Kernel();
    _zoomModel = new ZoomModel(this);
    new ZoomController(_zoomModel);
  }

  void setZoom(int v) => _kernel.director.setZoom(v);

  int zoom() => _zoomModel.zoom;
}

class ZoomView {
  ZoomModel zoomModel;
  ZoomController zoomController;
  DivElement _elZoomPlus;
  DivElement _elZoomMinus;
  
  ZoomView(this.zoomController, this.zoomModel);

  void createView() {
    // links
    _elZoomPlus = document.querySelector('#btns_zoop');
    _elZoomMinus = document.querySelector('#btns_zoom');

    // event handlers
    
    _elZoomPlus.onMouseDown.listen((Event e) => zoomController.zoomPlus());
    _elZoomPlus.onTouchStart.listen((Event e) {
      e.preventDefault();
      zoomController.zoomPlus();
    });
    
    _elZoomMinus.onMouseDown.listen((Event e) => zoomController.zoomMinus());
    _elZoomMinus.onTouchStart.listen((Event e) {
      e.preventDefault();
      zoomController.zoomMinus();
    });
  }

  void lockPlus() => _elZoomPlus.classes.add('btn_off');

  void unlockPlus() => _elZoomPlus.classes.remove('btn_off');
  
  void lockMinus() => _elZoomMinus.classes.add('btn_off');
  
  void unlockMinus() => _elZoomMinus.classes.remove('btn_off');

}

class ZoomController {
  ZoomModel _zoomModel;
  ZoomView _zoomView;

  ZoomController(this._zoomModel) {
    _zoomView = new ZoomView(this, _zoomModel);
    _zoomView.createView();
    _runView();
  }

  void _runView() {
    _checkLocks();
  }

  void _checkLocks() {
    if (_zoomModel.isMaxZoom()) _zoomView.lockPlus();
    else if (_zoomModel.isMinZoom()) _zoomView.lockMinus();
    else {
      _zoomView.unlockPlus();
      _zoomView.unlockMinus();
    }
  }

  void zoomPlus() {
    _zoomModel.zoomPlus();
    _checkLocks();
  }

  void zoomMinus() {
    _zoomModel.zoomMinus();
    _checkLocks();
  }

}

class ZoomModel {
  int _zoom;
  get zoom => _zoom;
  set zoom(int v) {
    _zoomLSS.value = v;
    _zoom = _zoomLSS.value;
  }
  ZoomLSS _zoomLSS;

  ZoomComponent component;

  ZoomModel(this.component) {
    _zoomLSS = new ZoomLSS('map:zoom');
    _zoom = _zoomLSS.value;
  }

  bool isMaxZoom() => zoom == 18; // 19

  bool isMinZoom() => zoom == 16; // 12

  void zoomPlus() {
    if (isMaxZoom()) return;
    int v = zoom;
    v++;
    zoom = v;
    component.setZoom(zoom);
  }

  void zoomMinus() {
    if (isMinZoom()) return;
    int v = zoom;
    v--;
    zoom = v;
    component.setZoom(zoom);
  }
}