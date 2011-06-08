
$(document).ready(function() {

//  $(".forms form.flag_form").hide();
//  $("#close_question_form").hide();
  $('.auto-link').autoVideo();
  var answers = $('article.answer').length;
  if(answers == 0){
    $('#new_answer').slideDown('slow');
    $('a#add_answer').addClass('active');
  }
  $("form.vote_form button").live("click", function(event) {
    var btn_name = $(this).attr("name");
    var form = $(this).parents("form");
    $.post(form.attr("action")+'.js', form.serialize()+"&"+btn_name+"=1", function(data){
      if(data.success){
        form.find(".votes_average").text(data.average);
        if(data.vote_state == "deleted") {
        }
        else {
          if(data.vote_type == "vote_down") {
          } else {
          }
        }
        Messages.show(data.message, "notice")
      } else {
        Messages.show(data.message, "error")
        if(data.status == "unauthenticate") {
          window.onbeforeunload = null;
          window.location="/users/login"
        }
      }
    }, "json");
    return false;
  });

  $(".comment-form").live("submit", function(event) {
    var form = $(this);
    var btn = form.find('button')
    btn.hide();
    $.post(form.attr("action"), form.serialize()+"&"+btn.attr("name")+"=1", function(data){
      if(data.success){
        if(data.vote_state == "deleted") {
        } else {
          btn.after('<span class="upvoted-comment">✓</span>');
          btn.remove();
        }
        btn.parents(".comment-votes").children(".votes_average").html(data.average);
        Messages.show(data.message, "notice")
      } else {
        Messages.show(data.message, "error")
      }
      btn.show();
    }, "json");
    return false;
  });

  $("form.mainAnswerForm .button").live("click", function(event) {
    var form = $(this).parents("form");
    var answers = $("#answers .block");
    var button = $(this)

    button.attr('disabled', true)
    if($("#wysiwyg_editor").length > 0 )
      $("#wysiwyg_editor").htmlarea('updateTextArea');
    $.ajax({ url: form.attr("action"),
      data: form.serialize()+"&format=js",
      dataType: "json",
      type: "POST",
      success: function(data, textStatus, XMLHttpRequest) {
                  if(data.success) {
                    window.onbeforeunload = null;

                    var answer = $(data.html)
                    answer.find("form.commentForm").hide();
                    answers.append(answer)
                    highlightEffect(answer)
                    Messages.show(data.message, "notice")
                    form.find("textarea").val("");
                    form.find("#markdown_preview").html("");
                    if($("#wysiwyg_editor").length > 0 )
                      $("#wysiwyg_editor").htmlarea('updateHtmlArea');
                    removeFromLocalStorage(location.href, "markdown_editor");
                  } else {
                    Messages.show(data.message, "error")
                    if(data.status == "unauthenticate") {
                      window.onbeforeunload = null;
                      window.location="/users/login"
                    }
                  }
                },
      error: Messages.ajax_error_handler,
      complete: function(XMLHttpRequest, textStatus) {
         button.attr('disabled', false)
      }
    });
    return false;
  });

  $("form.commentForm .button").live("click", function(event) {
    var form = $(this).parents("form");
    var commentable = $(this).parents(".commentable");
    var comments = commentable.find(".comments")
    var button = $(this)
    if($("#wysiwyg_editor").length > 0 )
      $("#wysiwyg_editor").htmlarea('updateTextArea');

    button.attr('disabled', true)
    $.ajax({ url: form.attr("action"),
             data: form.serialize()+"&format=js",
             dataType: "json",
             type: "POST",
             success: function(data, textStatus, XMLHttpRequest) {
                          if(data.success) {
                            var textarea = form.find("textarea");
                            window.onbeforeunload = null;
                            var comment = $(data.html)
                            comments.append(comment)
                            highlightEffect(comment)
                            Messages.show(data.message, "notice")
                            form.hide();
                            textarea.val("");
                            removeFromLocalStorage(location.href, textarea.attr('id'));
                          } else {
                            Messages.show(data.message, "error")
                            if(data.status == "unauthenticate") {
                              window.onbeforeunload = null;
                              window.location="/users/login"
                            }
                          }
                      },
             error: Messages.ajax_error_handler,
             complete: function(XMLHttpRequest, textStatus) {
               button.attr('disabled', false)
             }
    });
    return false;
  });

  $("#request_close_question_form").submit(function() {
    var request_button = $(this).find("input.button");
    request_button.attr('disabled', true);
    var close_button = $(this).find("button");
    close_button.attr('disabled', true);
    var form = $(this);

    $.ajax({
      url: $(this).attr("action"),
      data: $(this).serialize()+"&format=js",
      dataType: "json",
      type: "POST",
      success: function(data, textStatus, XMLHttpRequest) {
        if(data.success) {
          form.slideUp()
          Messages.show(data.message, "notice")
        } else {
          Messages.show(data.message, "error")
          if(data.status == "unauthenticate") {
            window.onbeforeunload = null;
            window.location="/users/login"
          }
        }
      },
      error: Messages.ajax_error_handler,
      complete: function(XMLHttpRequest, textStatus) {
        request_button.attr('disabled', false)
        close_button.attr('disabled', false)
      }
    });
    return false;
  });

  $(".edit_comment").live("click", function() {
    var comment = $(this).parents(".comment")
    var link = $(this)
    link.hide();
    $.ajax({
      url: $(this).attr("href"),
      dataType: "json",
      type: "GET",
      data: {format: 'js'},
      success: function(data) {
        comment = comment.append(data.html);
        link.hide()
        var form = comment.find("form.form")
        form.find(".cancel_edit_comment").click(function() {
          form.remove();
          link.show();
          return false;
        });

        var button = form.find("input[type=submit]");
        var textarea = form.find('textarea');
        form.submit(function() {
          button.attr('disabled', true)
          if($("#wysiwyg_editor").length > 0 )
            $("#wysiwyg_editor").htmlarea('updateTextArea');
          $.ajax({url: form.attr("action"),
                  dataType: "json",
                  type: "PUT",
                  data: form.serialize()+"&format=js",
                  success: function(data, textStatus) {
                              if(data.success) {
                                comment.find(".markdown").html('<p>'+data.body+'</p>');
                                form.remove();
                                link.show();
                                highlightEffect(comment);
                                Messages.show(data.message, "notice");
                                removeFromLocalStorage(location.href, textarea.attr('id'));
                                window.onbeforeunload = null;
                              } else {
                                Messages.show(data.message, "error")
                                if(data.status == "unauthenticate") {
                                  window.onbeforeunload = null;
                                  window.location="/users/login"
                                }
                              }
                            },
                  error: Messages.ajax_error_handler,
                  complete: function(XMLHttpRequest, textStatus) {
                    button.attr('disabled', false)
                  }
           });
           return false
        });
      },
      error: Messages.ajax_error_handler,
      complete: function(XMLHttpRequest, textStatus) {
        link.show()
      }
    });
    return false;
  });

  $(".Answer-commentable, .Question-commentable, .Comment-commentable").live("click", function() {
    var link = $(this);
    var answer_id = link.attr('data-commentable');
    var form = $('form[data-commentable='+answer_id+']')
    var textarea = form.find('textarea');
    form.slideToggle();
    textarea.focus();
    var viewportHeight = window.innerHeight ? window.innerHeight : $(window).height();
    var top = form.offset().top - viewportHeight/2;

    $('html,body').animate({scrollTop: top}, 1000);
    return false;
  });

  $('.cancel_comment').live('click', function(){
    $(this).parents('form').slideUp();
    return false;
  });

  $(".flag_form .cancel").live("click", function() {
    $(this).parents(".flag_form").slideUp();
    return false;
  });

  $(".close_form .cancel").live("click", function() {
    $(this).parents(".close_form").slideUp();
    return false;
  });

  $(".answer .flag-link").live("click", function() {
    var link = $(this);
    var href = link.attr('href');
    var controls = link.parents(".controls");
    if(!link.hasClass('busy')){
      link.addClass('busy');
      $.getJSON(href+'.js', function(data){
        controls.parents(".answer").find(".forms:first").html(data.html);
        link.removeClass('busy');
      })
    }
    return false;
  });

  $("#close_question_link").click(function() {
    $("#add_comment_form").slideUp();
    var link = $(this);
    var href = link.attr('href');
    if(!link.hasClass('busy')){
      link.addClass('busy');
      $.getJSON(href+'.js', function(data){
        var controls = link.parents('.controls');
        controls.find(".forms").html(data.html);
        link.removeClass('busy');
      })
    }
    return false;
  });

  $(".question-action").live("click", function(event) {
    var link = $(this);
    if(!link.hasClass('busy')){
      link.addClass('busy');
      var href = link.attr("href");
      var dataUndo = link.attr("data-undo");
      var title = link.attr("title");
      var dataTitle = link.attr("data-title");
      var img = link.children('img');
      var counter = $(link.attr('data-counter'));
      $.getJSON(href+'.js', function(data){
        if(data.success){
          link.attr({href: dataUndo, 'data-undo': href, title: dataTitle, 'data-title': title });
          img.attr({src: img.attr('data-src'), 'data-src': img.attr('src')});
          if(typeof(data.increment)!='undefined'){
            counter.text(parseFloat($.trim(counter.text()))+data.increment);
          }
          Messages.show(data.message, "notice");
        } else {
          Messages.show(data.message, "error");

          if(data.status == "unauthenticate") {
            window.onbeforeunload = null;
            window.location="/users/login";
          }
        }
        link.removeClass('busy');
        }, "json");
      }
    return false;
  });
});

$(window).load(function() {
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
});
