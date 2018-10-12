part of mailer_hub;

class Mailer {
  Maper _maper;
  WebSocket _sock;
  Kernel _k;
  Hash _hash;
  Map<String, DateTime> _delay;
  Finder _finder;
  bool _working;

  Mailer() {
    _maper = new Maper();
    _k = new Kernel();
    _delay = new Map<String, DateTime>();
    _working = false;
    _hash = new Hash();
  }

  // manage

  Future start() async {
    if (_working) return;
    _working = true;
    String secret;
    /** придут новые пакеты, поэтому чистим карту */
    _k.director.clearMaps();
    try {
      secret = await _maper.compute();
      if (secret.length < 60) {
        _closeSocket();
        Rec.it('ERR ошибка $secret начального подключения к серверу', always: true);
      } else {
        _sock = new WebSocket(secret);
        _sock.onOpen.listen((Event e) => _opened(e));
        _sock.onMessage.listen((MessageEvent e) => _inbox(e.data));
        _sock.onError.listen((Event e) => _error(e));
        _sock.onClose.listen((CloseEvent e) => _closed(e));
      }
    } catch (e) {
      _closeSocket();
      Rec.it('ERR ошибка подключения к серверу', always: true);
    }
  }

  /// Отключиться от сокета (вызывается из switcher) !
  void stop() {
    /** т.к. метод вызывается постоянно, то незачем делать что сделано */
    if (_working) _closeSocket();
  }

  // events

  void _opened(Event e) {
    // 1 stored hash
    _sendStored(_hash.activate());
    // 2 initials
    _finder = new Finder(); // !
    _sendInitial();
  } 

  void _closed(CloseEvent e) {
    _closeSocket();
  }

  void _closeSocket() {
    if (_finder != null) _finder.stop(); // !
    _finder = null; // !
    _closeSock(); // if (_sock != null) _sock.close(); _sock = null;
    _hash.inactive();
    _working = false; // правильно ? как закроется - можем снова открывать
  }

  void _error(Event e) {
    _closeSocket();
    /**
     * start(); или лучше switcher пусть это сдеалает ?
     * switcher пусть, он также учитывает внешние условия
     * активность вкладки и кнопку онлайн
     */
  }

  void _closeSock() {
    try {
      if (_isOpened()) _sock.send('X');
    } catch (e) {
      print('mailer closeSock $e');
    }
  }

  /// inbox : разбор входящих сообщений
  // csv
  void _inbox(dynamic data) {
    List list;
    if (data is String) list = data.split(',');
    else {
      print('WARN: mailer _inbox() data is not String');
      return;
    }
    int listLength = list.length;
    if (listLength < 1) {
      print('WARN: mailer _inbox() listLength < 1');
      return;
    }
    int code = int.parse(list[0]);

    switch (code) {
      case Codes.hashResponse: // 12
        if (listLength != 3) return;
        _hash.confirm(int.parse(list[1]), int.parse(list[2]));
        break;
      case Codes.move: // 30
        if (listLength != 5) return;
        _k.director.move('m', int.parse(list[1]), int.parse(list[2]), int.parse(list[3]), int.parse(list[4]));
        break;
      case Codes.remove: // 32 REMOVE
        if (listLength != 2) return;
        _k.director.remove(int.parse(list[1]));
        break;
      case Codes.recount: // 37 RECOUNT
        if (listLength != 1) return;
        // _k.director.recount();
        break;
      case Codes.sectorPackage: // 38
        int offset38 = 1;
        while (offset38 < listLength) {
          _k.director.move('m', int.parse(list[offset38++]), int.parse(list[offset38++]), int.parse(list[offset38++]), int.parse(list[offset38++]));
        }
        break;
      case Codes.liferOffline: // 39 OFFLINE
        if (listLength != 2) return;
        _k.director.offline(int.parse(list[1]));
        break;
      case Codes.globPackage: // 54
        int offset54 = 1;
        while (offset54 < listLength) {
          _k.director.move('g', int.parse(list[offset54++]), int.parse(list[offset54++]), int.parse(list[offset54++]), int.parse(list[offset54++]));
        }
        break;
      case Codes.statsResponse: // 69 STATS ANSWER
        if (listLength != 2) return;
        _k.helpComponent.write(int.parse(list[1]));
        break;
      default:
    }
  }
  // arraybuffer
  // void _inbox(dynamic data) {
  //   ByteData byteData = data.asByteData();
  //   int byteDataLength = byteData.lengthInBytes;
  //   if (byteDataLength < 1) return;
  //   int code = byteData.getUint8(0);

  //   switch (code) {
  //     case 12:
  //       if (byteDataLength != 9) return;
  //       int h = byteData.getUint32(1);
  //       int r = byteData.getUint32(5);
  //       _hash.confirm(h, r);
  //       break;
  //     case 30:
  //       if (byteDataLength != 14) return;
  //       int h30 = byteData.getUint32(1);
  //       int mla30 = byteData.getInt32(5);
  //       int mlo30 = byteData.getInt32(9);
  //       int mark30 = byteData.getUint8(13);
  //       // print('code30: $h30 $mla30 $mlo30 $mark30 gpsdata');
  //       _k.director.move('m', h30, mla30, mlo30, mark30);
  //       break;
  //     case 32: // REMOVE
  //       if (byteDataLength != 5) return;
  //       int h32 = byteData.getUint32(1);
  //       // print('code32: $h32 remove');
  //       _k.director.remove(h32);
  //       break;
  //     case 37: // RECOUNT
  //       if (byteDataLength != 1) return;
  //       // print('code37: recount sectors recomendation');
  //       break;
  //     case 38:
  //       int byteOffset38 = 1;
  //       int h38;
  //       int mla38;
  //       int mlo38;
  //       int mark38; 
  //       while (byteOffset38 < byteDataLength) {
  //         h38 = byteData.getUint32(byteOffset38);
  //         mla38 = byteData.getInt32(byteOffset38+4);
  //         mlo38 = byteData.getInt32(byteOffset38+8);
  //         mark38 = byteData.getUint8(byteOffset38+12);
  //         // print('code38: $h38 $mla38 $mlo38 $mark38 bufferOffset $byteOffset38');
  //         _k.director.move('m', h38, mla38, mlo38, mark38);
  //         byteOffset38 += 13;
  //       }
  //       break;
  //     case 39: // OFFLINE
  //       if (byteDataLength != 5) return;
  //       int h39 = byteData.getUint32(1);
  //       // print('code39: $h39 offline');
  //       _k.director.offline(h39);
  //       break;
  //     case 54:
  //       int byteOffset54 = 1;
  //       int h54;
  //       int mla54;
  //       int mlo54;
  //       int mark54; 
  //       while (byteOffset54 < byteDataLength) {
  //         h54 = byteData.getUint32(byteOffset54);
  //         mla54 = byteData.getInt32(byteOffset54+4);
  //         mlo54 = byteData.getInt32(byteOffset54+8);
  //         mark54 = byteData.getUint8(byteOffset54+12);
  //         // print('code54: $h54 $mla54 $mlo54 $mark54 package bufferOffset $byteOffset54');
  //         _k.director.move('g', h54, mla54, mlo54, mark54);
  //         byteOffset54 += 13;
  //       }
  //       break;
  //     case 69: // STATS ANSWER
  //       if (byteDataLength != 5) return;
  //       int stats69 = byteData.getUint32(1);
  //       // print('stats69: $stats69');
  //       _k.helpComponent.write(stats69);
  //       break;
  //     default:
  //   }
  // }

  // outbox : отправка сообщений

  /// CODE 11
  /// Отправка сохраненного hash (0 если не было или прошло 10 мин.)
  void _sendStored(int code) {
    if ([Codes.changeHash, Codes.restoreHash].contains(code) == false) return;
    // csv         data.split(',');
    String data = [code, _hash.hash, _hash.regh].join(',');
    sendCsv(data);
    // arraybuffer
    // ByteData byteData;
    // byteData = new ByteData(9);
    // byteData.setUint8(0, code); // code 10 or 11
    // byteData.setUint32(1, _hash.hash);
    // byteData.setUint32(5, _hash.regh);
    // send(byteData.buffer.asUint8List());
  }

  /// Первоначальное заполнение сокета после открытия соединения
  void _sendInitial() {
    _k.settings.sendCurrentSamf();
    _k.director.sendCurrentGps();
  }

  /// CODE 18
  /// отправить samf (из settings)
  void sendSamf(int samf) {
    // csv
    String data = [Codes.samf, samf].join(','); // 18
    sendCsv(data);
    // arraybuffer
    // ByteData byteData = new ByteData(5);
    // byteData.setUint8(0, 18);
    // byteData.setUint32(1, samf);
    // Uint8List uint8list = byteData.buffer.asUint8List();
    // send(uint8list);
  }

  void sendSamfDelay(int samf) {
    const int delay = 1800; // milliseconds
    const String key = 'samf';
    DateTime was = new DateTime.now();
    _delay[key] = was;
    new Timer(const Duration(milliseconds: delay), () {
      DateTime now = _delay[key];
      if (was == now) {
        /**
         * придут новые пакеты, поэтому чистим карту
         */
        _k.director.clearMaps();
        sendSamf(samf);
      }
    });
  }

  /// CODE 50
  void sendGlob(Map bounds) {
    // csv
    String data = [Codes.globRequest, bounds['tamla'], bounds['tamlo'], bounds['tcmla'], bounds['tcmlo']].join(',');
    sendCsv(data);
    // arraybuffer
    // ByteData byteData = new ByteData(17);
    // byteData.setUint8(0, 50);
    // byteData.setInt32(1, bounds['tamla']);
    // byteData.setInt32(5, bounds['tamlo']);
    // byteData.setInt32(9, bounds['tcmla']);
    // byteData.setInt32(13, bounds['tcmlo']);
    // Uint8List uint8list = byteData.buffer.asUint8List();
    // send(uint8list);
  }

  void sendGlobDelay(Map bounds) {
    const int delay = 1800; // milliseconds
    const String key = 'glob';
    DateTime was = new DateTime.now();
    _delay[key] = was;
    new Timer(const Duration(milliseconds: delay), () {
      DateTime now = _delay[key];
      if (was == now) {
        sendGlob(bounds);
      }
    });
  }

  /// Запросить статистику
  /// code 68
  void stats() {
    // csv
    sendCsv('${Codes.statsRequest}');
    // arraybuffer
    // ByteData byteData = new ByteData(1);
    // byteData.setUint8(0, 68);
    // Uint8List uint8list = byteData.buffer.asUint8List();
    // send(uint8list);
  }

  void statsDelay() {
    const int delay = 1800; // milliseconds
    const String key = 'stats';
    DateTime was = new DateTime.now();
    _delay[key] = was;
    new Timer(const Duration(milliseconds: delay), () {
      DateTime now = _delay[key];
      if (was == now) {
        stats();
      }
    });
  }

  /// CODES 20-24
  /// отравить gpsdata (из director)
  void sendGPS(Map gpsdata) {
    //csv
    String data = [gpsdata['code'], gpsdata['mla'], gpsdata['mlo']].join(',');
    sendCsv(data);
    // arraybuffer
    // ByteData byteData = new ByteData(9);
    // byteData.setUint8(0, gpsdata['code']);
    // byteData.setInt32(1, gpsdata['mla']);
    // byteData.setInt32(5, gpsdata['mlo']);
    // Uint8List uint8list = byteData.buffer.asUint8List();
    // send(uint8list);
  }

  // common methods

  /// Отправить данные через ws
  // csv
  void sendCsv(String data) {
    if (_isOpened()) _sock.send(data);
  }
  // arraybuffer
  void send(Uint8List data) {
    if (_isOpened()) _sock.send(data);
    // else ? NOTHING
  }

  bool _isOpened() => _sock != null && _sock.readyState == WebSocket.OPEN;

}