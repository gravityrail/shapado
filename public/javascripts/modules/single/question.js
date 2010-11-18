$(document).ready(function() {
  $("textarea").focus(function() {
    if(!window.onbeforeunload) {
      window.onbeforeunload = function() {
        var filled = false;
        $('textarea').each(function(){
          if($.trim($(this).val())!=''){
            filled = true;
          }
        })
        if(filled) {return I18n.on_leave_page; }
        return null;
      }
    }
  });

  $("#reward_reputation" ).hide();
  var slider_div = $("#reward_slider");
  slider_div.slider({
    value:50,
    min: 50,
    max: slider_div.attr("data-max"),
    step: 50,
    slide: function( event, ui ) {
      $("#reward_value").text(ui.value);
      $("#reward_reputation").val( ui.value );
    }
  });
})
