var Tags = {
  initialize: function() {
    $(".follow-tag, .unfollow-tag").live("click", function(event) {
      var link = $(this);
      if(!link.hasClass('busy')){
        link.addClass('busy');
        var href = link.attr("href");
        var title = link.text();
        var dataTitle = link.attr("data-title");
        var dataUndo = link.attr("data-undo");
        var linkClass = link.attr('class');
        var dataClass = link.attr('data-class');
        var tag = link.attr('data-tag');
        $.ajax({
          url: href+'.js',
          dataType: 'json',
          type: "POST",
          data: "tags="+tag,
          success: function(data){
            if(data.success){
              link.attr({href: dataUndo, 'data-undo': href, 'data-title': title, 'class': dataClass, 'data-class': linkClass });
              Messages.show(data.message, "notice");
            } else {
              Messages.show(data.message, "error");

              if(data.status == "unauthenticate") {
                  window.location="/users/login";
              }
          }
          },
          error: manageAjaxError,
          complete: function(XMLHttpRequest, textStatus) {
              link.removeClass('busy');
              link.text(dataTitle);
          }
        });
      }
      return false;
    });
  }
}