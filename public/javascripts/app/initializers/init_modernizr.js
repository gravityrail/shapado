Modernizr.load([{
  load: '//ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js',
  callback: function() {
    if (!window.jQuery) {
      Modernizr.load('/javascripts/vendor/jquery.js');
    }
  },
  complete: function() {
    Modernizr.load([{
      load: jsassets.offline_bare_minimum_questions,
      complete: function(){
        Questions.initialize_on_show();
      }
    }, {
      load: cssassets.jqueryui
    }, {
      load: jsassets.jqueryui,
      complete: function() {
        $('.lang-fields').tabs();
        Effects.initialize();
      }
    }, {
      test: ($('.offline').length == 0 || (location.pathname != '/' && location.pathname.indexOf('/questions' != 0))),
      yep: jsassets.base
    }, {
      test: window.JSON,
      nope: jsassets.json
    }, {
      test: Modernizr.websockets,
      nope: jsassets.websocket,
      complete: function() {
        ShapadoSocket.initialize();
      }
    }])
  }
}]);