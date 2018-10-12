library observable;

/// Паттрен Наблюдатель

/// Наблюдаемый
abstract class Observable {
  void registerObserver(Observer o);
}

/// Наблюдатель
abstract class Observer {
  void update();
}