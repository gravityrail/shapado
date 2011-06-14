var FbQuestions = {
  initialize: function() {
    if($(".unauthenticated").length > 0) {
      $("input, textarea").focus(function() {
        Auth.open_popup('/users/auth/facebook');
      });

      $(".require_login").click(function() {
        Auth.open_popup('/users/auth/facebook');
        return false;
      });
    }

    $("article.Question h3 a").click(function() {
      var l = $(this);
      var q = l.parents("article.Question");

      q.find(".question-body").slideToggle();

      return false;
    });

    $(".quick_question form").submit(function() {
      var f = $(this);
      var step1 = f.find(".step1");
      var step2 = f.find(".step2");

      var href = f.attr("action");

      if(!step2.is(':visible')) {
        step2.slideDown();
      } else {
        $.ajax({
          url: href+'.js',
          dataType: 'json',
          type: "POST",
          data: f.serialize()+"&facebook=1",
          success: function(data){
            if(data.success){
              step2.slideUp();

              Messages.show(data.message, "notice");
              $("section.questions-index").prepend(data.html);
            } else {
              Messages.show(data.message, "error");

              if(data.status == "unauthenticate") {
                Auth.open_popup("/users/auth/facebook");
              }
            }
          },
          error: Messages.ajax_error_handler,
          complete: function(XMLHttpRequest, textStatus) {
          }
        });
      }
      return false;
    });
  }
};

$(document).ready(function() {
  FbQuestions.initialize();
});
