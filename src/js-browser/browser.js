
(function browser() {
    // if (['chrome','firefox'].indexOf(Detectizr.browser.name) != -1) {
    if (['chrome'].indexOf(Detectizr.browser.name) != -1) {
        var script = document.createElement('script');
        script.src = 'js/bundle.js';
        script.async = false;
        document.head.appendChild(script);
    } else {
        var loading = document.getElementById('loading');
        var loadingText = loading.firstElementChild;
      loadingText.innerHTML = 'Ваш браузер здесь не подходит. Используйте Яндекс.Браузер или Google&nbsp;Chrome!';
    }
})();