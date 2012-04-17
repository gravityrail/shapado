Effects = function(){
  var self =this;

  function initialize() {
    $('ul.menubar').droppy({
      className:    'dropHover',
      autoArrows:    false,
      trigger: 'click'
    });

    $('ul.menubar .has-subnav').click(function(e) {
      e.preventDefault();
    })

    $(".highlight_for_user").effect("highlight", {}, 2000);

    $(".btn-answer").click(function() {
      $("#panel-answer").slideToggle("slow");
      $(this).toggleClass("active"); return false;
    });
  }

  function fade(object) {
    if(typeof object != "undefined") {
      object.fadeOut(400, function() {
        object.fadeIn(400)
      });
    }
  }

  return {
    initialize:initialize,
    fade:fade
  }
}();
