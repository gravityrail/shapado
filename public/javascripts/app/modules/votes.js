var Votes = {
  initialize: function() {
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
  update_on_index: function(data) {

  },
  update_on_show: function(data) {

  }
};
