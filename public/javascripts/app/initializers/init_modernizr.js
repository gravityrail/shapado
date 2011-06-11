jqueryui_assets =
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
    load: jsassets.offline_bare_minimum_questions
  },
  {
    test: $('meta[data-js=show]').length>0,
    yep: jsassets.offline_bare_minimum_show,
    callback: function(){
      Editor.initialize();
    }
  },
  {
    load: cssassets.jqueryui
  },
  {
    load: jsassets.jqueryui,
    complete:  function(){
      $('.lang-fields').tabs();
      Effects.initialize();
    }
  },
  {
    test: ($('.offline').length==0 || (location.pathname!='/' && location.pathname.indexOf('/questions'!=0))),
    yep: jsassets.base
  },
  {
    test: $('meta[data-jqmath]').length > 0,
    yep: eval($('meta[data-jqmath]').attr('data-jqmath-assets'))
  },
  {
    test: $('meta[data-js=show]').length>0 && $('.auto-link').length>0,
    yep: jsassets.jqueryautovideo,
    callback: function(){
      $('.auto-link').autoVideo();
    }
  },
  {
    test: window.JSON,
    nope: jsassets.json
  },
  {
    load: jsassets.websocket,
    complete: function(){
      ShapadoSocket.initialize();
    }
  },
  {
    test: $('.autocomplete_for_tags').length > 0,
    yep: jsassets.jqautocomplete,
    callback: function(){
      $('.autocomplete_for_tags').ricodigoComplete();
    }
  }
      ])
    }
  }
]);
