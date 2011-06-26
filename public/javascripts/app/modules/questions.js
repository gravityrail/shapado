var Questions = {
  initialize: function() {
    if($("section#question.main-question").length > 0) {
      Questions.initialize_on_index();
    } else if($("section#main-question").length > 0) {
      Questions.initialize_on_show();
    }
  },
  initialize_on_index: function() {

  },
  initialize_on_show: function() {
    Modernizr.load([{
      test: ($('meta[data-js=show]').length > 0 || location.pathname == '/questions/new') && $('meta[data-js=show][data-loaded]').length == 0,
      yep: jsassets.offline_bare_minimum_show,
      complete: function(){
        Ui.hide_comments_form();
        if(window.Rewards)
          Rewards.initialize();
        if(window.Editor)
          Editor.initialize();
        $('meta[data-js=show]').attr({'data-loaded': 1})
      }
    }, {
      test: $('meta[data-js=show]').length > 0 && $('.auto-link').length > 0,
      yep: jsassets.jqueryautovideo,
      complete: function(){
        if($.fn.autoVideo)
          $('.auto-link').autoVideo();
      }
    }, {
      test: $('meta[data-jqmath]').length > 0,
      yep: eval($('meta[data-jqmath]').attr('data-jqmath-assets'))
    }, {
      test: $('.autocomplete_for_tags').length > 0,
      yep: jsassets.jqautocomplete,
      callback: function() {
        $('.autocomplete_for_tags').ricodigoComplete();
      }
    }])
  },
  create_on_index: function(data) {
    var section = $("section.questions-index");
    section.prepend(data.html).hide().slideToggle();
  },
  create_on_show: function(data) {
  },
  update_on_index: function(data) {
    var key = "article.Question#"+data.object_id;
    for(var prop in data.changes) {
      if(prop == "title") {
        var n = data.changes[prop].pop();
        $(key+" h2 a").text(n);
      }
    }
  },
  update_on_show: function(data) {
    var key = "section#question.main-question."+data.object_id;
    for(var prop in data.changes) {
      switch(prop) {
        case "title": {
          var n = data.changes[prop].pop();
          $(key+" h1:first").text(n);
        }
        break;
        case "body": {
          var n = data.changes[prop].pop();
          $(key+" .description").html(n);
        }
        break;
      }

    }
  },
  update_widgets: function(data) {

  }
}
