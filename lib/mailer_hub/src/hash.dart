part of mailer_hub;

class Hash {

  HashLSS _lssHash;
  int _hash;
  get hash => _hash; // mailer получает hash постоянно, но в первый раз .activate()
  set hash(int v) { // mailer записывает после обновления - у него данные
    _lssHash.value = v;
    _hash = _lssHash.value;
    _last = new DateTime.now(); // переписываем, т.к. предыдущий мог быть давно
  }

  // reghash - если сервер перегрузили, все hash'и клиентов не действительны !
  HashLSS _lssRegh;
  int _regh;
  get regh => _regh;
  set regh(int v) {
    _lssRegh.value = v;
    _regh = _lssRegh.value;
  }

  DateTime _last; // last activity
  
  Kernel _k;

  Hash() {
    _k = new Kernel();
    _lssHash = new HashLSS('hash:h');
    _hash = _lssHash.value;
    _last = new DateTime.now(); 
    // после перезагрузки - точка отсчета обычная, т.е. наоборот срок обновления удлинняется (если до перезагрузки время уже подошло, то перезагрузка отдаляет срок вновь); логика обновления hash - обновляться регулярно, но не давать пользователю это делать
    // Hash создается Mailer'ом один раз
    // Получение hash выполняется каждый раз при подключении сокета - это время подходит для обновления hash
    _lssRegh = new HashLSS('hash:r');
    _regh = _lssRegh.value;
    if (regh == 0) hash = 0;
  }

  /// Рестарт активности
  /// Получения hash после паузы
  /// при открытии соединения
  int activate() {
    int code = 11; // RESTORE HASH
    DateTime now = new DateTime.now();
    if (hash == 0) code = 10; // CHANGE HASH
    if (now.difference(_last).inMinutes >= 10) code = 10;
    return code;
  }

  /// Подтверждаем получение hash с сервера
  void confirm(int h, int r) {
    // возвращаются валидные hash и reghash, записываем их если они изменились
    if (regh != r) {
      regh = r;
      hash = h;
      /**
       * Сервер перегружается, значит, его reghash меняется.
       * Поскольку у нас looper, то соединение сразу восстанавливается.
       * Сервер присылает валидные reghash и hash (отличные от сохраненных).
       * Нужно сохранить валидные значения 
       * (карту не нужно чистить, т.к. это делается раньше - в mailer.start()).
       */
    } else if (hash != h) hash = h;
    /**
     * Когда меняется только hash, это стандартная ситуация.
     * Нужно его записать и работать теперь с ним.
     * Старого hash уже нигде нет (ни на сервере, ни на клиентах).
     */
  }

  /// Отметка окончания периода активности
  /// при закрытии соединения
  void inactive() => _last = new DateTime.now();

}