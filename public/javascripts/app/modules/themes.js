var Themes = {
  initialize: function($body) {
    if($body.hasClass("show")) {
      var message = $body.find("#not_ready")
      if(message.length > 0) {
        var show_theme = document.location.href;
        $.poll(5000, function(retry){
          $.getJSON(show_theme+"/ready", {format: "js"}, function(response, status) {
            if(status == 'success' && (response.ready))
              if(response.message) {
                message.text(response.message);
                Effects.fade(message);
                if(show_theme == document.location.href)
                  document.location.href = document.location.href;
              } else if(response.last_error) {
                message.text(response.last_error);
                message.addClass("error");
                Effects.fade(message);
              }
            else
              retry();
          });
        });
      }
    } else if( $body.hasClass("new") || $body.hasClass("edit") || $body.hasClass("create") || $body.hasClass("update")) {
      $("textarea.code").each(function(i, e){
        CodeMirror.fromTextArea(e, {lineNumbers: true, theme: "default", mode: $(e).data("lang")});
      });
    }
  }
}
