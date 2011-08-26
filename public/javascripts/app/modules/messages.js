var Messages = {
  initialize: function() {
    $("a#hide_announcement").click(function() {
      $(".announcement").fadeOut();
      $.get($(this).attr("href"), "format=js");
      return false;
    });
  },
  show: function(message, t, delay) {
    $("#notifyBar").remove();
    $.notifyBar({
      html: "<div class='message "+t+"' style='width: 100%; height: 100%; padding: 5px'>"+message+"</div>",
      delay: delay||3000,
      animationSpeed: "normal",
      barClass: "flash"
    });
  },
  ajax_error_handler: function(XMLHttpRequest, textStatus, errorThrown) {
    Messages.show("sorry, something went wrong.", "error");
  }
};
