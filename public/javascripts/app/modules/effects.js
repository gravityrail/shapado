// Efects
var Effects = {
  initialize: function() {
    $(".highlight_for_user").effect("highlight", {}, 2000);

    $(".btn-answer").click(function() {
      $("#panel-answer").slideToggle("slow");
      $(this).toggleClass("active"); return false;
    });

    jQuery('ul.drop-menu').superfish({
      hoverClass:    'dropHover',
      autoArrows:    false
    });
  },
  fade: function(object) {
    if(typeof object != "undefined") {
      object.fadeOut(400, function() {
        object.fadeIn(400)
      });
    }
  }
};
