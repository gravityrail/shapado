
$(document).ready(function() {
  Questions.initialize_on_show();
  var answers = $('article.answer').length;
  if(answers == 0){
    $('#new_answer').slideDown('slow');
    $('a#add_answer').addClass('active');
  }

  $("form.mainAnswerForm .button").live("click", function(event) {
    var form = $(this).parents("form");
    var answers = $("#answers .block");
    var button = $(this)

    button.attr('disabled', true)
    if($("form .wysiwyg_editor").length > 0 )
      $("form .wysiwyg_editor").htmlarea('updateTextArea');
    $.ajax({ url: form.attr("action"),
      data: form.serialize()+"&format=js",
      dataType: "json",
      type: "POST",
      success: function(data, textStatus, XMLHttpRequest) {
                  if(data.success) {
                    window.onbeforeunload = null;

                    var answer = $(data.html);
                    answer.find("form.commentForm").hide();
                    answers.append(answer);
                    Effects.fade(answer);
                    Messages.show(data.message, "notice")
                    form.find("textarea").val("");
                    form.find(".markdown_preview").html("");
                    if($(".wysiwyg_editor").length > 0 )
                      $(".wysiwyg_editor").htmlarea('updateHtmlArea');
                    LocalStorage.remove(location.href, "markdown_editor");
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


  $(".flag_form").delegate(".cancel", "click", function() {
    $(this).parents(".flag_form").slideUp();
    return false;
  });

  $(".close_form").delegate(".cancel", "click", function() {
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
