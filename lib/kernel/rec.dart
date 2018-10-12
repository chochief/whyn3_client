library rec;

import 'package:WhynClient/kernel/config.dart';

class Rec {
  static it(String text, {bool always: false}) {
    if (always || Config.record) print('${new DateTime.now()} $text');
  }
}