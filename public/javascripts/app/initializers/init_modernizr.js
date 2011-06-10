Modernizr.load([
  {
    load: '//ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js',
    callback: function () {
      if ( !window.jQuery ) {
            Modernizr.load('/javascripts/vendor/jquery.js');
      }
    },
    complete: function(){
      Modernizr.load([
  {
    load: '/packages/offline_bare_minimum_questions.js'
  },
  {
    test: $('meta[data-js=show]').length>0,
    yep: '/packages/offline_bare_minimum_show.js',
    callback: function(){
      Editor.initialize();
    }
  },
  {
    load: ['/packages/jqueryui.js', '/packages/jqueryui.css'],
    callback:  function(){
      $('.lang-fields').tabs();
      Effects.initialize();
    }
  },
  {
    test: ($('.offline').length==0 || (location.pathname!='/' && location.pathname.indexOf('/questions'!=0))),
    yep: '/packages/base.js'
  },
  {
    test: $('meta[data-jqmath]').length > 0,
    yep: eval($('meta[data-jqmath]').attr('data-jqmath-assets'))
  },
  {
    test: $('meta[data-js=show]').length>0 && $('.auto-link').length>0,
    yep: '/packages/jqueryautovideo.js',
    callback: function(){
      $('.auto-link').autoVideo();
    }
  },
  {
    test: window.JSON,
    nope: '/packages/json.js'
  },
  {
    load: '/packages/websocket.js',
    complete: function(){
      ShapadoSocket.initialize();
    }
  },
  {
    test: $('.autocomplete_for_tags').length > 0,
    yep: '/packages/jqautocomplete.js',
    callback: function(){
      $('.autocomplete_for_tags').ricodigoComplete();
    }
  }
      ])
    }
  }
]);
