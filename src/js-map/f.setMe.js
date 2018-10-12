
function setMe(lat, lon) {
  me.lat = lat;
  me.lon = lon;
  moveMe();
}

function moveMe() {
  // map
  m.me.geometry.setCoordinates([me.lat, me.lon]);
  // m.map.setCenter([me.lat, me.lon], m.map.zoom, { duration: 500 });
  m.map.setCenter([me.lat, me.lon], m.map.zoom, { duration: 100 });
  m.circle100.geometry.setCoordinates([me.lat, me.lon]);
  m.circle300.geometry.setCoordinates([me.lat, me.lon]);
  m.circle500.geometry.setCoordinates([me.lat, me.lon]);
  m.circle700.geometry.setCoordinates([me.lat, me.lon]);
  // glob
  g.me.geometry.setCoordinates([me.lat, me.lon]);
  g.circle100.geometry.setCoordinates([me.lat, me.lon]);
  g.circle300.geometry.setCoordinates([me.lat, me.lon]);
  g.circle500.geometry.setCoordinates([me.lat, me.lon]);
  g.circle700.geometry.setCoordinates([me.lat, me.lon]);
}