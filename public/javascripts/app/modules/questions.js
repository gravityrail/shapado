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
    Ui.hide_comments_form();
    $(".toolbar").shapadoToolbar({formContainer: "#panel-forms"});
    $(".article-actions").shapadoToolbar({formContainer: ".article-forms"});
    if(typeof(Effects) !== 'undefined'){
      Effects.initialize();
    }
    Rewards.initialize();
    Editor.initialize();
    Votes.initialize_on_question();
    Comments.initialize_on_question();
    if(typeof(Jqmath)!='undefined')
      Jqmath.initialize();
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
};
