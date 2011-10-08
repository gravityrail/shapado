var Comments = {
  initialize_on_question: function(data) {
    $('.comment-votes form.comment-form button.vote').hide();

    $.each($("a.toggle_comments"), function() {
      var l = $(this);
      var n = l.nextAll("article.read");
      var s = n.length;
      if(s < 5) {
        l.hide();
      } else {
        l.show();
        var t = l.text().replace("NN", s);
        l.text(t);
        n.hide();
        l.next("article.comment:last").show();
      }
    });

    $("a.toggle_comments").click(function() {
      $(this).nextAll("article.read").slideToggle();
      return false;
    });

    $(".content-panel").delegate(".comment", "hover", function(handlerIn, handlerOut) {
      var show = (handlerIn.type == "mouseenter");
      $(this).find(".comment-votes form.comment-form button.vote").toggle(show);
    });

    $(".content-panel").delegate(".comment-votes .comment-form", "submit", function(event) {
      var form = $(this);
      var btn = form.find('button');
      btn.attr('disabled', true);
      btn.hide();
      $.post(form.attr("action"), form.serialize()+"&"+btn.attr("name")+"=1", function(data){
        if(data.success){
          if(data.vote_state == "destroyed") {
            btn.addClass("vote");
            btn.hide();
          } else {
            btn.removeClass("vote");
            btn.show();
          }
          btn.parents(".comment-votes").children(".votes_average").html(data.average);
          Messages.show(data.message, "notice");
        } else {
          Messages.show(data.message, "error");
        }
        btn.attr('disabled', false);
        btn.show();
      }, "json");
      return false;
    });

    $(".content-panel").delegate("form.commentForm, form.question_comment_form", "submit", function(event) {
      var form = $(this);
      var comments = form.parents(".panel-comments").prev('.comments');
      var button = form.find("input[type=submit]");
      if($(".wysiwyg_editor").length > 0 )
        $(".wysiwyg_editor").htmlarea('updateTextArea');

      button.attr('disabled', true);
      $.ajax({ url: form.attr("action"),
              data: form.serialize()+"&format=js",
              dataType: "json",
              type: "POST",
              success: function(data, textStatus, XMLHttpRequest) {
                            if(data.success) {
                              var textarea = form.find("textarea");
                              window.onbeforeunload = null;
                              var comment = $(data.html);
                              if(data.updated){
                                Comments.update_on_show(data);
                              } else {
                                Comments.create_on_show(data);
                              }
                              Messages.show(data.message, "notice")
                              form.hide();
                              textarea.val("");
                              LocalStorage.remove(location.href, textarea.attr('id'));
                            } else {
                              Messages.show(data.message, "error")
                              if(data.status == "unauthenticate") {
                                window.onbeforeunload = null;
                                window.location="/users/login";
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

    $(".content-panel").delegate(".edit_comment", "click", function() {
      var comment = $(this).parents(".comment")
      var link = $(this);
      link.hide();
      $.ajax({
        url: $(this).attr("href"),
        dataType: "json",
        type: "GET",
        data: {format: 'js'},
        success: function(data) {
          comment = comment.append(data.html);
          link.hide()
          var form = comment.find("form.edit_comment_form");
          Editor.setup(form.find(".markdown_editor, .wysiwyg_editor"));
          form.find(".cancel_edit_comment").click(function() {
            form.remove();
            link.show();
            return false;
          });

          var button = form.find("input[type=submit]");
          var textarea = form.find('textarea');
          form.submit(function() {
            button.attr('disabled', true)
            if($(".wysiwyg_editor").length > 0 )
              $(".wysiwyg_editor").htmlarea('updateTextArea');
            $.ajax({url: form.attr("action"),
                    dataType: "json",
                    type: "PUT",
                    data: form.serialize()+"&format=js",
                    success: function(data, textStatus) {
                                if(data.success) {
                                  form.remove();
                                  link.show();
                                  Effects.fade(comment);
                                  comment.replaceWith(data.html);
                                  Messages.show(data.message, "notice");
                                  LocalStorage.remove(location.href, textarea.attr('id'));
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

    $(".Question-commentable").click(Comments.showCommentForm);

    $(".content-panel").delegate(".Answer-commentable, .Comment-commentable", "click", Comments.showCommentForm);

    $('.cancel_comment').live('click', function(){
      $(this).parents('form').slideUp();
      return false;
    });
  },
  showCommentForm: function() {
      var link = $(this);
      var answer_id = link.attr('data-commentable');
      var form = $('form[data-commentable='+answer_id+']');
      var textarea = form.find('textarea');
      form.slideToggle();
      textarea.focus();
      var viewportHeight = window.innerHeight ? window.innerHeight : $(window).height();
      var top = form.offset().top - viewportHeight/2;

      $('html,body').animate({scrollTop: top}, 1000);
      return false;
  },
  create_on_index: function(data) {
  },
  create_on_show: function(data) {
    var comment = $('#'+data.object_id);
    if(comment.length==0){
      var commentable = $('.'+data.commentable_id);
      var comments = commentable.find('.comments');
      comments.append(data.html);
      Effects.fade(comment);
    }
  },
  update_on_index: function(data) {

  },
  update_on_show: function(data) {
    var comment = $('#'+data.object_id);
    if($.trim(comment.html()) != data.html){
      comment.replaceWith(data.html);
      Effects.fade(comment);
    }
  },
  vote: function(data) {
  }
};
