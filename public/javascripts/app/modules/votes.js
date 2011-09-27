var Votes = {
  initialize: function() {
  },
  initialize_on_questions: function() {
    $(".quick-vote-button").live("click", function(event) {
      var btn = $(this);
      btn.hide();
      var src = btn.attr('src');
      if (src.indexOf('/images/dialog-ok.png') == 0){
        var btn_name = $(this).attr("name")
        var form = $(this).parents("form");
        $.post(form.attr("action"), form.serialize()+"&"+btn_name+"=1", function(data){
          if(data.success){
            btn.parents('.item').find('.votes .counter').text(data.average);
            btn.attr('src', '/images/dialog-ok-apply.png');
            Messages.show(data.message, "notice")
          } else {
            Messages.show(data.message, "error")
            if(data.status == "unauthenticate") {
              window.onbeforeunload = null;
              window.location="/users/login"
            }
          }
          btn.show();
        }, "json");
      }
      return false;
    });
  },
  initialize_on_question: function() {
    $(".answer").delegate("form.vote_form button", "click", function(event) {
      if(Ui.offline()){
        Auth.startLoginDialog();
      } else {
        var btn_name = $(this).attr("name");
        var form = $(this).parents("form");
        $.post(form.attr("action")+'.js', form.serialize()+"&"+btn_name+"=1", function(data){
          if(data.success){
            form.find(".votes_average").text(data.average);
            if(data.vote_state == "destroyed") {
              form.find("button").removeClass("checked");
            }
            else {
              if(data.vote_state == "updated") {
                form.find("button").removeClass("checked");
              }
              if(data.vote_type == "vote_down") {
                form.find("button.negative").addClass("checked");
              } else {
                form.find("button.positive").addClass("checked");
              }
            }
            Messages.show(data.message, "notice");
          } else {
            Messages.show(data.message, "error");
            if(data.status == "unauthenticate") {
              window.onbeforeunload = null;
              window.location="/users/login";
            }
          }
        }, "json");
      }
      return false;
    });
  },
  update_on_index: function(data) {
  },
  update_on_show: function(data) {
  }
};
