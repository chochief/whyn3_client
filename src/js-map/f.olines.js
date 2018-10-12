
function setOnline() {
  g.online = true;
  clearThey();
}

function setOffline() {
  g.online = false;
  clearThey();
  setMe(offdata.me.lat, offdata.me.lon);
  offdata.points.forEach(function(pv, pi) {
    // m
    if (pi != offdata.num) changes(m, 'i'+pi, pv[0][0], pv[0][1], 1, 'sample');
    changes(m, 'f1' + pi, pv[1][0], pv[1][1], 0, 'sample');
    changes(m, 'm2' + pi, pv[2][0], pv[2][1], 1, 'sample');
    changes(m, 'n3' + pi, pv[3][0], pv[3][1], 6, 'sample');
    changes(m, 'n4' + pi, pv[4][0], pv[4][1], 8, 'sample');
    changes(m, 'f5' + pi, pv[5][0], pv[5][1], 0, 'sample');
    changes(m, 'm6' + pi, pv[6][0], pv[6][1], 1, 'sample');
    // g
    if (pi != offdata.num) changes(g, 'i'+pi, pv[0][0], pv[0][1], 1, 'sample');
    changes(g, 'f1' + pi, pv[1][0], pv[1][1], 0, 'sample');
    changes(g, 'm2' + pi, pv[2][0], pv[2][1], 1, 'sample');
    changes(g, 'n3' + pi, pv[3][0], pv[3][1], 6, 'sample');
    changes(g, 'n4' + pi, pv[4][0], pv[4][1], 8, 'sample');
    changes(g, 'f5' + pi, pv[5][0], pv[5][1], 0, 'sample');
    changes(g, 'm6' + pi, pv[6][0], pv[6][1], 1, 'sample');
  });
}

/**
 * Очистить they manager для m и g
 */
function clearThey() {
  if (m.they != null) m.they.removeAll();
  if (g.they != null) g.they.removeAll();
  m.index = {};
}

/**
 * Внести изменения для точки h на карте to
 * to (m либо g)
 * если нет - добавить, если есть - переместить или изменить вид
 */
function changes(to, h, la, lo, mrk, sector) {
  var id = compId(to, h);
  var o;
  if (to.name == 'm') {
    var mid = to.index[id];
    if (mid != null) o = to.they.get(mid);
    if (o == null) addPoint(to, id, la, lo, mrk, sector);
    else {
      o.geometry.setCoordinates([la, lo]);
      o.properties.set('sector', sector);
      o.options.set(remarkOptions(m, mrk));
    }
  } else if (to.name == 'g') {
    o = to.they.objects.getById(id);
    if (o == null) addPoint(to, id, la, lo, mrk);
    // else nothing - нет возможности изменять координаты, хотя внешний вид можно:
    // to.they.objects.setObjectOptions(id, remarkOptions(to, mrk));
  }
}

/**
 * Вычисляет id для точки по hash и to
 * to (m либо g)
 * h (hash)
 */
function compId(to, h) {
  var id;
  if (to.name == 'm') id = 'm' + h;
  else if (to.name == 'g') id = 'g' + h;
  else throw new Error('Недопустимый to.name!');
  return id;
}

/**
 * Добавить точку
 * to (m либо g)
 */
function addPoint(to, id, la, lo, mrk, sector) {
  var options = remarkOptions(to, mrk);
  if (to.name == 'm') {
    var o = new ymaps.Placemark([la, lo], {}, options);
    o.properties.set('sector', sector);
    to.they.add(o);
    to.index[id] = to.they.indexOf(o); // сохраняем index GeoObjectCollection
  } else if (to.name == 'g') { // ObjectManager
    to.they.add({
      type: 'Feature',
      id: id,
      geometry: {
        type: 'Point',
        coordinates: [la, lo]
      },
      options: options
    });
  }
}

/**
 * Вычислить options для добавляемой точки по mark
 * to (m либо g) ! разные умолчания для меток
 * возвращает options
 */
// размеры, смещение иконок на карте, объекты опций
var iconSizeL = 16, iconSizeL2 = -(iconSizeL / 2);
var iconSizeS =  8, iconSizeS2 = -(iconSizeS / 2);
var options0 = {
  iconImageClipRect: avaBy(2, 5),
  iconImageSize: [iconSizeL, iconSizeL],
  iconImageOffset: [iconSizeL2, iconSizeL2]
};
var options1 = {
  iconImageClipRect: avaBy(2, 4),
  iconImageSize: [iconSizeL, iconSizeL],
  iconImageOffset: [iconSizeL2, iconSizeL2]
};
var options6 = {
  iconImageClipRect: avaBy(2, 6),
  iconImageSize: [iconSizeL, iconSizeL],
  iconImageOffset: [iconSizeL2, iconSizeL2]
};
var options8 = {
  iconImageClipRect: avaBy(2, 2),
  iconImageSize: [iconSizeS, iconSizeS],
  iconImageOffset: [iconSizeS2, iconSizeS2]
};
function remarkOptions(to, mrk) {
  var options = {};
  // для g везде все по умолчанию
  switch (mrk) {
    case 0: // f онлайн
      if (to.name == 'm') options = options0;
      break;
    case 1: // m онлайн
      if (to.name == 'm') options = options1;
      break;
    case 6: // n онлайн
      if (to.name == 'm') options = options6;
      break;
    case 8: // офлайн
      if (to.name == 'm') options = options8;
      break;
  }
  return options;
}
