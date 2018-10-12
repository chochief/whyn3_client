library config;

class Config {
  
  /**
   * В отличие от серверной части, на клиенте бесполезно делать config.yaml
   * т.к. файл подтягивается при выпонении, а не при сборке.
   * Т.е. нужно удобно переключать конфигурацию при сборке - здесь.
   */

  // prod || dev
  static const String env = 'prod';

  // common options
  static String app = 'WhynClient';
  static int dist = 9; // дистанция минимального перемещения (в метрах)
  static bool record = true;
  static const Duration switcher = const Duration(milliseconds: 800);

  // special option
  static String url;

  void load() {
    switch (env) {
      case 'dev':
        url = 'ws://127.0.0.1:4040';
        break;
      case 'prod':
        url = 'wss://whatsyourna.me:8888';
        break;
      default:
    }
  }

}