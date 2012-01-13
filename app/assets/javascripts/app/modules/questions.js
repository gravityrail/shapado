var Questions = {
  initialize: function($body) {
    if($body.hasClass("show")) {
      Questions.initialize_on_show($body);
    } else if($body.hasClass("index")) {
      Questions.initialize_on_index($body);
    } else if($body.hasClass("new") || $body.hasClass("edit")) {
      Questions.initialize_on_new($body);
    } else if($body.hasClass("move")) {
      Questions.initialize_on_move($body);
    }
  },
  initialize_on_index: function($body) {
    Ui.navigate_shortcuts($(".questions-index"), ".Question");
    $(".Question .toolbar").shapadoToolbar();
    Votes.initialize_on_questions();

    var extraParams = Utils.url_vars();
    extraParams['format'] = 'js';

//     FIXME:filter is blocking mongodb
    $(".quick_question #ask_question").searcher({
      url : "/questions/related_questions.js",
      target : $(".questions-index"),
      fields : $(".quick_question #ask_question input#question_title"),
      behaviour : "live",
      timeout : 500,
//       minLength: 5,
      extraParams : extraParams,
      success: function(data) {
        $('#additional_info .pagination').html(data.pagination);
      }
    });

    $(".flag-link-index").live("click", function(event) {
      var link = $(this).parents("article.Question").find("h2 a");
      if(link) {
        window.location= link.attr("href")+"#to_flag"
      }
      return false;
    });
  },
  initialize_on_show: function($body) {
    $(".main-question .toolbar").shapadoToolbar({formContainer: "#panel-forms"});
    $("article.answer .toolbar").shapadoToolbar({formContainer: ".article-forms", afterFetchForm : function(link, form) {
      Editor.setup(form.find(".markdown_editor, .wysiwyg_editor"));
    }});
    $(".answer .toolbar, .comment .toolbar").shapadoToolbar({formContainer: ".article-forms", afterFetchForm: function(link, form) {
      Editor.setup(form.find(".markdown_editor, .wysiwyg_editor"));
    }});
    Rewards.initialize();
    Editor.initialize();
    Votes.initialize_on_question();
    Comments.initialize_on_question();
    Answers.initialize_on_question();

    if(typeof(Jqmath)!='undefined')
      Jqmath.initialize();

    var anchor = document.location.hash;
    if(anchor == "#to_answer") {
      var add_answer = $("a#add_answer")
      add_answer.trigger('click');
      $('html,body').animate({scrollTop: add_answer.offset().top-100}, 1000);
    } else if(anchor == "#to_flag") {
      var flag_question = $("a#flag_question")
      flag_question.trigger('click');
      $('html,body').animate({scrollTop: flag_question.offset().top-100}, 1000);
    }
    prettyPrint();
  },
  initialize_on_new: function($body) {
    $("#related_questions").hide();
    Editor.initialize();
    $("#question_tags").ajaxChosen({
      method: 'GET',
      url: '/questions/tags_for_autocomplete.js',
      dataType: 'json'
    }, function (data) {
      var terms = {};
      $.each(data, function (i, val) {
          console.log('i: '+i)
          console.log('val: '+val)
        terms[val["value"]] = val["caption"];
      });

      return terms;
    });


//     FIXME:filter is blocking mongodb
    $(".ask_question #ask_question").searcher({url : "/questions/related_questions.js",
      target : $("#related_questions"),
      fields : $("form#ask_question input[type=text][name*=question]"),
      behaviour : "focusout",
      timeout : 2500,
      extraParams : { 'format' : 'js',
                      'per_page' : 5,
                      mini: true
      },
      before_query: function(target) {
        target.show();
      },
      success: function(data) {
        if(!data.html) {
          $("#related_questions").hide();
          // TODO: show a message
        }
        $("label#rqlabel").show();
      }
    });

    var fields = $("#attachments #fields");
    var template = fields.find(".template");
    template.find("input").attr("name", "question[attachments[id]]");
    template.hide();

    $("#attachments #fields .attachment_field .remove_attachment").live("click", function(e) {
      $(this).parent().remove();
      return false;
    });

    $(".remove_attachment_link").live("click", function(e) {
      var url = $(this).attr("href");
      var remove = confirm("are you sure?"); //TODO; i18n
      if (remove) {
        $.ajax({url: url, dataType: 'json', context: $(this), success: function(data, textStatus, XMLHttpRequest){
          $(this).parent().remove();
        }});
      }
      return false;
    });

    var count = -1;
    $("#attachments .add_attachment").live("click", function(e) {
      var template = fields.find(".template");
      var new_field = template.clone();
      new_field.removeClass("template");
      count++;
      var new_name = new_field.find("input").attr("name").replace(/(id)/, count);
      new_field.find("input").attr("name",new_name)

      new_field.show();

      fields.append(new_field);

      return false;
    });
  },
  initialize_on_move: function(data) {
    if($('#groups_slug').length){
      $('#groups_slug').autocomplete({
        source: "/groups/autocomplete_for_group_slug.json",
        minLength: 1,
        select: function( event, ui ) {
            $('#groups_slug').val(ui.item.slug);
            return false;
        }
      })
      .data( "autocomplete" )._renderItem = function( ul, item ) {
        return $( "<li></li>" )
          .data( "item.autocomplete", item )
          .append( "<a>" + item.slug + "</a>" )
          .appendTo( ul );
      };
    }
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
