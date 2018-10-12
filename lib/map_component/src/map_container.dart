part of map_component;

abstract class MapSource {
  void load();
  void unload();
  void drawCopyright(DivElement copyright);


  ScriptElement _addScript(String src) {
    ScriptElement el = new ScriptElement();
    el.src = src;
    el.type = "text/javascript";
    el.async = false;
    return el;
  } 
}

/// Mock Console Map
class Consolemap extends MapSource {
  
  @override
  void load() => print('Console Map: loaded');

  @override
  void unload() => print('Console Map: unloaded');
  

  @override
  void drawCopyright(DivElement copyright) {
    copyright.classes.add('ya-copyright');
    DivElement elContent = new DivElement();
    DivElement elText = new DivElement();
    elContent.classes.add('ya-copyright__content-cell');
    elText.classes.add('ya-copyright__text');
    elText.text = '© ConsoleMap';

    elContent.children.add(elText);
    copyright.children.add(elContent);
  }
}

class Yamaps extends MapSource {
  final _lib = "https://api-maps.yandex.ru/2.1/?lang=ru_RU"; // "https://api-maps.yandex.ru/2.1/?lang=en_US"
  final _script;
  ScriptElement _elLibFile;
  ScriptElement _elScriptFile;

  Yamaps(this._script) {
    _make();
  }

  void _make() {
    _elLibFile = _addScript(_lib);
    _elScriptFile = _addScript(_script);
  }

  @override
  void load() {
    document.head.children.add(_elLibFile);
    document.head.children.add(_elScriptFile);
  }

  @override
  void unload() {
    // просто заложена возможность выгрузки
    _elScriptFile.remove();
    _elLibFile.remove();
  }

  @override
  void drawCopyright(DivElement copyright) {
    copyright.classes.add('ya-copyright');
    DivElement elContent = new DivElement();
    DivElement elText = new DivElement();
    AnchorElement elAgreement = new AnchorElement();
    DivElement elLogo = new DivElement();
    AnchorElement elLink = new AnchorElement();
    elContent.classes.add('ya-copyright__content-cell');
    elText.classes.add('ya-copyright__text');
    elText.text = '© Яндекс';
    elAgreement.classes.add('ya-copyright__agreement');
    elAgreement.text = 'Условия';
    elAgreement.href = 'http://yandex.ru/legal/maps_termsofuse/';
    elAgreement.target = '_blank';
    elLogo.classes.add('ya-copyright__logo-cell');
    elLink.classes.add('ya-copyright__link');
    elLink.href = 'https://yandex.ru/maps/';
    elLink.target = '_blank';

    elContent.children.add(elText);
    elContent.children.add(elAgreement);
    elLogo.children.add(elLink);

    copyright.children.add(elContent);
    copyright.children.add(elLogo);
  }

}

class MapContainer implements Rotatable {
  DivElement _elMapContainer;
  DivElement _elCopyright;
  DivElement _elMap;
  DivElement _elGlob;
  DivElement _elLoading;
  MapSource _mapSource;

  // h к w (соотношение сторон относительно точки Iam (Me))
  // w = 1/2
  // h -> 2/3 || 3/5 || 4/7
  final int h1 = 3;
  final int h2 = 5;

  MapContainer(this._mapSource) {
    _createView();

    // events
    window.onResize.listen((Event e) => _resizeMap());
  }

  void _createView() {
    // links
    _elMapContainer = document.querySelector('#map_container');
    _elCopyright = _elMapContainer.querySelector('#copyright');
    _elMap = _elMapContainer.querySelector('#map');
    _elGlob = _elMapContainer.querySelector('#glob');
    _elLoading = document.querySelector('#loading');
    
    // установка размеров контейнера
    _resizeMap();

    _mapSource.drawCopyright(_elCopyright);

    // загрузка карты
    _mapSource.load();
    
  }

  /// Установка размеров блока карты
  void _resizeMap() {
    int w = document.documentElement.clientWidth;
    int h = document.documentElement.clientHeight;
    num r = sqrt(h1*h1*h*h/(h2*h2) + w*w/4);
    num t = r - h1*h/h2;
    num l = r - w/2;
    _elMap.style.width = '${2*r}px';
    _elMap.style.height = '${2*r}px';
    _elMap.style.left = '${-l}px';
    _elMap.style.top = '${-t}px';
    // glob
    int g = 25;
    _elGlob.style.height = '${h+g}px';
    _elGlob.style.bottom = '${-g}px';
  }

  /// Показать карту и убрать панель Loading
  void enable() {
    new Timer(const Duration(seconds: 2), () {
      showCopyright();
      showMap();
      hideLoading();
    });
  }

  void hideLoading() => _elLoading.classes.add('hidden');
  
  void removeMap() => _mapSource.unload();

  void showMap() => _elMap.classes.remove('hidden');

  void hideMap() => _elMap.classes.add('hidden');

  void showCopyright() => _elCopyright.classes.remove('hidden');

  void hideCopyright() => _elCopyright.classes.add('hidden');

  @override
  // void setRotate(int v) => _elMap.style.transform = 'rotate($v)deg';
  void setRotate(int v) {
    _elMap.style.transform = 'rotate(${v}deg)';
  }

}