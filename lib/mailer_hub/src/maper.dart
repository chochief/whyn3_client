part of mailer_hub;

class Maper {
  final String url = Config.url;
  String _k0;

  Maper() {
    int _k11 = _qk(_gk(1));
    _at(_k11);
  }

  Future<String> compute() async {
    Completer<String> secret = new Completer<String>();
    WebSocket socket;
    try {
      // запрос временного хэша через wss://.../socket (иначе CORS)
      socket = new WebSocket([url, 'socket'].join('/'));
      // socket.onError.first.then((_) {
      //   if (socket != null) socket.close(); // ! закрываем временный сокет
      //   secret.complete('E'); // ! отправляем код E
      // });
      socket.onError.listen((Event event) {
        _closeSocket(socket); // ! закрываем временный сокет
        secret.complete('E'); // ! отправляем код E
      });
      socket.onMessage.listen((MessageEvent e) {
        _closeSocket(socket); // ! закрываем временный сокет
        dynamic t0 = e.data;
        if (t0 is String) {
          // создаем и отправляем строку подключения
          String h0 = _hmac(_k0, '$t0$_k0');
          String m0 = '$h0$t0';
          secret.complete([url, m0].join('/'));
        } else {
          secret.complete('F');
        }
      });
    } catch (e) { 
      _closeSocket(socket);
      secret.complete('U'); // ! отправляем код U
    }
    return secret.future;
  }

  void _closeSocket(WebSocket s) {
    try {
      if (s != null && s.readyState == WebSocket.OPEN) s.send('X');
    } catch (e) {
      print('maper closeSocket $e');
    }
  }

  int _gk(int pc) => 6*3*7*9;

  void _at(int k1) => _k0 = k1.toString();

  String _hmac(String k, String msg) {
    var key = UTF8.encode(k);
    var bytes = UTF8.encode(msg);
    var hmacSha256 = new Hmac(sha256, key);
    return hmacSha256.convert(bytes).toString();
  }

  int _qk(int gpc) => gpc*18*2*4*6*9;

}