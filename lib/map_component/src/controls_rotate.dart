part of map_component;

abstract class Rotatable {
  void setRotate(int v);
}

class RotatableMock implements Rotatable {
  @override
  void setRotate(int v) => print('RotatableMock: called setRotate()');
}

class RotateComponent implements Rotatable {
  RotateModel _model;
  
  /// Компонент поворачивает другой компонент
  /// а именно, map container
  Rotatable _rotatable;

  RotateComponent(this._rotatable) {
    _model = new RotateModel(_rotatable);
    new RotateController(_model);
  }

  /// Компонент может быть повернут извне
  @override
  void setRotate(int v) => _model.setRotate(v);
}

class RotateView implements Observer {
  RotateModel _model;
  RotateController _controller;
  DivElement _elToLeft;
  DivElement _elToRight;
  DivElement _elCompass;

  RotateView(this._controller, this._model) {
    _model.registerObserver(this);
  }

  void createView() {
    // links
    _elToLeft = document.querySelector('#btns_rotl');
    _elToRight = document.querySelector('#btns_rotr');
    _elCompass = document.querySelector('#compass');

    // event handlers
    _elCompass.onMouseDown.listen((Event e) => _controller.rotateToNorth());
    _elCompass.onTouchStart.listen((Event e) {
      e.preventDefault();
      _controller.rotateToNorth();
    });

    _elToLeft.onMouseDown.listen(_onMouseDown);
    _elToLeft.onTouchStart.listen(_onTouchStart);

    _elToRight.onMouseDown.listen(_onMouseDown);
    _elToRight.onTouchStart.listen(_onTouchStart);
    
    _elToLeft.onMouseUp.listen(_onMouseUp);
    _elToLeft.onTouchEnd.listen(_onTouchEnd);
    
    _elToRight.onMouseUp.listen(_onMouseUp);
    _elToRight.onTouchEnd.listen(_onTouchEnd);

  }

  void _onMouseDown(Event e) => _rotateProcessing(e);

  void _onTouchStart(Event e) {
    e.preventDefault();
    _rotateProcessing(e);
  }

  void _onMouseUp(Event e) => _stopRotateProcessing(e);

  void _onTouchEnd(Event e) {
    e.preventDefault();
    _stopRotateProcessing(e);
  }

  void _rotateProcessing(Event e) {
    Element el = e.target;
    if (el.id == 'btns_rotl') _controller.rotateToLeft();
    else if (el.id == 'btns_rotr') _controller.rotateToRight();
  }

  void _stopRotateProcessing(Event e) => _controller.stopRotateProcessing();

  void rotateCompass(num v) => _elCompass.style.transform = 'rotate(${v}deg)';

  @override
  void update() => _controller.rotateButtons();
}

class RotateController {
  RotateModel _model;
  RotateView _view;
  bool _rotateNow;
  Timer _timer;

  RotateController(this._model) {
    _view = new RotateView(this, _model);
    _view.createView();
    _runView();
    _rotateNow = false;
  }

  void _runView() {
    rotateToNorth();
  }

  void rotateToLeft() {
    if (_rotateNow) return;
    _rotateNow = true;
    _timer = new Timer.periodic(const Duration(milliseconds: 40), (Timer t) {
      // _timer = t;
      _model.rotateToLeft();
    });
  }

  void rotateToRight() {
    if (_rotateNow) return;
    _rotateNow = true;
    _timer = new Timer.periodic(const Duration(milliseconds: 40), (Timer t) {
      _model.rotateToRight();
    });
  }

  void rotateToNorth() {
    _model.rotateToNorth();
  }

  void rotateButtons() {
    _view.rotateCompass(_model.rotate);
  }

  void stopRotateProcessing() {
    if (_timer != null) _timer.cancel();
    _rotateNow = false;
  }

}

class RotateModel implements Rotatable, Observable {
  Rotatable rotatable;

  final discreteAngle = 3;
  
  int _rotate;
  get rotate => _rotate;

   RotateModel(this.rotatable) {
    _rotate = 0;
  }

  void _rotateAll() {
    _notifyObservers();
    rotatable.setRotate(_rotate);
  }

  void rotateToLeft() {
    // if (_isDividing(_rotate, discreteAngle)) _rotate += discreteAngle;
    // else _rotate = (_rotate / discreteAngle).ceil() * discreteAngle;
    _rotate += discreteAngle;
    _rotateAll();
  }

  // bool _isDividing(int n1, int n2) => n1.remainder(n2) == 0;

  void rotateToRight() {
    // if (_isDividing(_rotate, discreteAngle)) _rotate -= discreteAngle;
    // else _rotate = (_rotate / discreteAngle).floor() * discreteAngle;
    _rotate -= discreteAngle;
    _rotateAll();
  }

  void rotateToNorth() {
    _rotate = 0;
    _rotateAll();
  }

  @override
  void setRotate(int v) {
    // вызываем уже реализованные методы в контроллере
    // нет. считаем _rotate и _courseBtnRotate и notify view, а также rotateble отправляем команду и значение поворота
    
    // ...
    _rotateAll();
  }

  /// Observable

  List<Observer> _observers = new List<Observer>();

  @override
  void registerObserver(Observer o) {
    _observers.add(o);
  }

  void _notifyObservers() {
    for (var i = 0; i < _observers.length; i++) {
      _observers[i].update();
    }
  }
}