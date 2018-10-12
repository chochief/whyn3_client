library whyn_client;

import 'dart:html';

import 'package:WhynClient/kernel/kernel.dart';
// import 'common/browser.dart';

start() {

  // Browser browser = new Browser();
  // if (browser.unsupported()) {
  //   document.querySelector('#loading .loading__text').innerHtml = 'Ваш браузер здесь не подходит. Используйте Яндекс.Браузер или Google&nbsp;Chrome!';
  //   return;
  // }
  document.querySelector('#browser').classes.remove('hidden'); // ie в ударе !

  // kernel
  Kernel kernel = new Kernel();
  kernel.burn();

}
