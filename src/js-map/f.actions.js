
function clearMaps() {
  clearThey();
}

function backHome() {
  // g.map.setCenter([me.lat, me.lon], g.zoom, { duration: 500 });
  g.map.setCenter([me.lat, me.lon], g.zoom, { duration: 100 });
}

function setZoom(zoom_value) {
  m.zoom = zoom_value;
  // m.map.setZoom(m.zoom, { duration: 200 });
  m.map.setZoom(m.zoom, { duration: 100 });
}

function reglob(quick) {
  var code = quick === true ? 'GLOB_GET' : 'GLOB_BOUNDS';
  js2dart(code, g.map.getBounds());
  g.they.removeAll(); 
  // сразу чистим и ждем данные с сервера, иначе будет неясно что запросили
}

// codes 38, 30
function move(data) {
  if (data.to == 'm') changes(m, data.h, data.la, data.lo, data.m, data.s);
  else if (data.to == 'g') changes(g, data.h, data.la, data.lo, data.m, data.s);
}

// code 39
function offline(h) {
  var id = compId(m, h);
  var o = m.they.get(m.index[id]);
  if (o != null) o.options.set(remarkOptions(m, 8));
}

// code 32
function remove(h) {
  var id = compId(m, h);
  var mid = m.index[id];
  if (mid != null) {
    var o = m.they.get(mid);
    if (o != null) m.they.remove(o);
    m.index[id] = null;
  }
}

// code 37
function recount(sectors) {
  m.they.each(function(o) {
    if (sectors.indexOf(o.properties.get('sector')) == -1) m.they.remove(o);
  });
}