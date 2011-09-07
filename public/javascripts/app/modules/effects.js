// Efects
var Effects = {
  initialize: function() {
    console.log("Effects.initialize")
    $('ul.sf-menu').droppy({
      className:    'dropHover',
      autoArrows:    false,
      trigger: 'click'
    });

    $('ul.sf-menu .has-subnav').click(function(e) {
      e.preventDefault();
    })

    $(".highlight_for_user").effect("highlight", {}, 2000);

    $(".btn-answer").click(function() {
      $("#panel-answer").slideToggle("slow");
      $(this).toggleClass("active"); return false;
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
