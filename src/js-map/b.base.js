
var href = localHref();

// map object
var m = {
  name: 'm',
  index: {}
};

// glob object
var g = {
  name: 'g',
  online: false
};

// me object
var me = {};

// inbox

function receiveFromDart(event) {
  if (checkOrigin(event.origin) == false) return; // !security

  var data = jsonParse(event.data);
  if (data == false) return;
  if (data.type == null || data.type != 'dart2js') return;

  // routes by data.code

  if (data.code == null) return;
  // map & glob inits
  else if (data.code == 'INIT_MAPS_OFFLINE') initMapsOffline(data.zoom);
  else if (data.code == 'INIT_MAPS_ONLINE') initMapsOnline(data.lat, data.lon, data.zoom);
  // 
  else if (data.code == 'CLEAR_MAPS') clearMaps();
  else if (data.code == 'SET_OFFLINE') setOffline();
  else if (data.code == 'SET_ONLINE') setOnline();
  else if (data.code == 'SET_ZOOM') setZoom(data.value);
  else if (data.code == 'BACK_HOME') backHome();
  else if (data.code == 'UPDATE_US') setMe(data.lat, data.lon);
  else if (data.code == 'MOVE') move(data);
  else if (data.code == 'OFFLINE') offline(data.h);
  else if (data.code == 'REMOVE') remove(data.h);
  else if (data.code == 'RECOUNT') recount(data.sectors);
  else if (data.code == 'REGLOB') reglob(data.quick);

}

window.addEventListener("message", receiveFromDart, false);

// outbox

function readyMaps() {
  js2dart('MAP_READY', 'ok');
}

ymaps.ready(readyMaps);

function js2dart(code, payload) {
  var data = jsonEncode({
    type: 'js2dart',
    code: code,
    payload: payload
  });
  window.postMessage(data, href);
}