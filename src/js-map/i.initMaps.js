
function initMapsOnline(lat, lon, zoom) {
  me.lat = lat;
  me.lon = lon;
  m.zoom = zoom;
  g.online = true;
  initMap();
  initGlob();
}

function initMapsOffline(zoom) {
  me.lat = offdata.me.lat;
  me.lon = offdata.me.lon;
  m.zoom = zoom;
  g.online = false;
  initMap();
  initGlob();
  setOffline();
}

function initMap() {
  addMap(m, 'map', false);
  addMe(m, 20);
  addBoundsEvent(m, 'MAP_BOUNDS');
  addTheyManager(m, 18);
}

function initGlob() {
  g.zoom = 16;
  addMap(g, 'glob', true);
  addMe(g, 16);
  // globBoundsChanged(g.map.getBounds());
  addBoundsEvent(g, 'GLOB_BOUNDS');
  addTheyManager(g, 8);
}

/**
 * Добавление карты
 * to (m или g)
 * divId m: map
 * divId g: glob
 * drag: m - false, g - true
 */
function addMap(to, divId, drag) {
  to.map = new ymaps.Map(divId, { zoom: to.zoom, center: [me.lat, me.lon], controls: [] }, { suppressMapOpenBlock: true });
  to.map.balloon.destroy();
  var behaviors = ["rightMouseButtonMagnifier", "scrollZoom", "dblClickZoom", "multiTouch", "leftMouseButtonMagnifier"];
  if (drag === false) behaviors.push("drag");
  to.map.behaviors.disable(behaviors);
}

/**
 * Добавление me
 * to (m или g)
 * iconSize m: 20 -10
 * iconSize g: 16 -8
 */
function addMe(to, iconSize) {
  to.me = new ymaps.Placemark([me.lat, me.lon],
    { /* hintContent: false,*/ },
    {
      cursor: cursor(to),
      iconLayout: "default#image",
      iconImageHref: "img/points.png",
      iconImageClipRect: avaBy(1, 4),
      iconImageSize: [iconSize, iconSize],
      iconImageOffset: [-(iconSize / 2), -(iconSize / 2)],
      zIndex: 106
    }
  );
  to.map.geoObjects.add(to.me);
  addCircles(to);
}

// Возвращает тип курсора в зависимости от карты
// m - arrow (т.к. нет drag)
// g - grab (т.к. есть drag)
function cursor(to) {
  return to.name == 'm' ? 'arrow' : 'grab';
}

/**
 * Добавляет круги вокруг me
 * to - m либо g (т.е. на map или glob)
 */
function addCircles(to) {
  [100, 300, 500, 700].forEach(function (radius) {
    var c = new ymaps.Circle([
      // Координаты центра круга.
      [me.lat, me.lon],
      // Радиус круга в метрах.
      radius
    ],
      {},
      {
        cursor: cursor(to),
        fill: false,
        strokeColor: '#000000',
        strokeOpacity: 0.1,
        strokeWidth: 1,
        strokeStyle: '2 3'
      });
    to.map.geoObjects.add(c);
    if (radius == 100) to.circle100 = c;
    else if (radius == 300) to.circle300 = c;
    else if (radius == 500) to.circle500 = c;
    else if (radius == 700) to.circle700 = c;
  });
}

/**
 * Добавление события изменения границ
 * to (m либо g)
 * code m: 'MAP_BOUNDS' g: 'GLOB_BOUNDS'
 */
function addBoundsEvent(to, code) {
  to.map.events.add('boundschange', function (e) {
    if (e.get('newBounds') != e.get('oldBounds ')) {
      bounds = e.get('newBounds');
      js2dart(code, bounds);
      if (to.name == 'g' && g.online === true) g.they.removeAll(); 
      // удаляем точки если был drag и ждем новые данные
    }
  });
}

/**
 * Добавление they (ObjectManager)
 * to - m либо g (т.е. на map или glob)
 * iconSize m: 18 -9
 * iconSize g:  8 -4
 */
function addTheyManager(to, iconSize) {
  var clipRect;
  if (to.name == 'm') { // GeoObjectCollection
    clipRect = avaBy(2, 6);
    to.they = new ymaps.GeoObjectCollection({}, {
      zIndex: 105,
      cursor: 'arrow',
      iconLayout: 'default#image',
      iconImageHref: 'img/points.png',
      iconImageClipRect: clipRect,
      iconImageSize: [iconSize, iconSize],
      iconImageOffset: [-(iconSize / 2), -(iconSize / 2)]
    });
    to.map.geoObjects.add(to.they);
  } else if (to.name == 'g') { // ObjectManager
    clipRect = avaBy(2, 2);
    to.they = new ymaps.ObjectManager({
      clusterize: false
    });
    to.they.objects.options.set("zIndex", 105);
    to.they.objects.options.set("cursor", "grab");
    to.they.objects.options.set("iconLayout", "default#image");
    to.they.objects.options.set("iconImageHref", "img/points.png");
    to.they.objects.options.set("iconImageClipRect", clipRect);
    to.they.objects.options.set("iconImageSize", [iconSize, iconSize]);
    to.they.objects.options.set("iconImageOffset", [-(iconSize / 2), -(iconSize / 2)]);
    to.map.geoObjects.add(to.they);
  }
}
