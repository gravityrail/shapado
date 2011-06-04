var QuestionUI = {
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
