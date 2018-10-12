part of map_component;

class Courier {
  String _origin;
  Director _director;

  Courier(this._director) {
    _setOrigin();
    window.onMessage.listen(_onWindowMessage);
  }
  
  void _setOrigin() {
    String href = window.location.href;
    _origin = href.substring(0, href.length-1);
  }

  void _onWindowMessage(MessageEvent event) {
    if (event.origin != _origin) {
      return; // !security
    }
    Map data; // вместо dynamic
    try {
      data = JSON.decode(event.data);
    } catch (e) {
      data = null;
    }
    _director.route(data);
  }

  void dart2js(String code, Map payload) {
    var data = new Map<String, Object>();
    data['type'] = 'dart2js';
    data['code'] = code;
    // data['payload'] = payload;
    if (payload.isNotEmpty) data.addAll(payload);
    String jsonData = JSON.encode(data);
    // print(jsonData);
    window.postMessage(jsonData, _origin);
  }

}