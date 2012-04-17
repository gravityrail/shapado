Comments = function() {
  var self = this;

  function initializeOnQuestion(data) {
    $('.comment-votes form.comment-form button.vote').hide();
    var forms = $('.question_comment_form, .answer_comment_form');
    forms.find('.buttons').hide();

    forms.delegate('textarea', 'focus', function() {
      var form = $(this).parents('form');
      form.find('.buttons').show();
      if(!form.find('textarea').hasClass(form.data('editor'))) {
        form.find('textarea').addClass(form.data('editor'));
        Editor.setup(form.find('textarea'));
      }
    });

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
        l.parents('.comments').find("article.comment:last").show();
      }
    });

    $("a.toggle_comments").click(function() {
      $(this).nextAll("article.read").toggle();
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
                                updateOnShow(data);
                              } else {
                                createOnShow(data);
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

    $(".Question-commentable").click(showCommentForm);

    $(".content-panel").delegate(".Answer-commentable, .Comment-commentable", "click", showCommentForm);

    $('.cancel_comment').live('click', function(){
      var form = $(this).parents('form');
      form.find('.buttons').hide();
      var htmlarea = form.find('.jHtmlArea')
      if(htmlarea.length > 0) {
        htmlarea.remove();
        form.find('.markdown').append('<textarea class="text_area" cols="auto" id="comment_body" name="comment[body]" placeholder="Add comment" rows="auto"></textarea>');
      } else {
        form.find('.markdown_toolbar').remove();
        form.find('textarea').removeClass('markdown_editor')
      }
      return false;
    });
  }

  function showCommentForm() {
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
  }

  function createOnIndex(data) {
  }

  function createOnShow(data) {
    var comment = $('#'+data.object_id);
    if(comment.length==0){
      var commentable = $('.'+data.commentable_id);
      var comments = commentable.find('.comments');
      comments.append(data.html);
      Effects.fade(comment);
    }
  }

  function updateOnIndex(data) {

  }

  function updateOnShow(data) {
    var comment = $('#'+data.object_id);
    if($.trim(comment.html()) != data.html){
      comment.replaceWith(data.html);
      Effects.fade(comment);
    }
  }

  function vote(data) {
  }

  return {
    initializeOnQuestion:initializeOnQuestion,
    showCommentForm:showCommentForm,
    createOnIndex:createOnIndex,
    createOnShow:createOnShow,
    updateOnIndex:updateOnIndex,
    updateOnShow:updateOnShow,
    vote:vote
  }
}();
