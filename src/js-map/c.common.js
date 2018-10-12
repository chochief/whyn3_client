
// common functions

function jsonEncode(obj) {
  var string;
  try {
    string = JSON.stringify(obj);
  } catch (error) {
    string = '';
  }
  return string;
}

function jsonParse(str) {
  var parsed;
  try {
    parsed = JSON.parse(str)
  } catch (e) {
    parsed = false;
  }
  return parsed;
}

function localHref() {
  var href = window.location.href;
  return href.substring(0, href.length - 1);
}

function checkOrigin(origin) {
  return origin == href;
}

/**
 * Возвращает массив с координатами спрайта points.png
 * col - столбец > 0
 * row - строка > 0
 * avaBy(1,1) -> [[0,0],[64,64]]
 * avaBy(1,2) -> [[0,64],[64,128]]
 * avaBy(1,3) -> [[0,128],[64,192]]
 * avaBy(2,1) -> [[64,0],[128,64]]
 * avaBy(2,3) -> [[64,128],[128,192]]
 * avaBy(2,4) -> [[64,192],[128,256]]
*/
function avaBy(col, row) {
  var len = 64;
  if (!isInteger(col) || !isInteger(row) || col < 1 || row < 1)
    return [];
  return [[(col - 1) * len, (row - 1) * len], [col * len, row * len]];
}

/**
 * Возвращает true если аргумент целое число, иначе false
 * -5, 0, 54 -> true
*/
function isInteger(num) {
  return (num ^ 0) === num;
}

/**
 * Возвращает случайное целое
 * между min и max, включая min и max
*/
function randomInt(min, max) {
  var rand = min + Math.random() * (max + 1 - min);
  rand = Math.floor(rand);
  return rand;
}