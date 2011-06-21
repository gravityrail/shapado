var Updater = {
  initialize: function() {
    $("a[data-ajax=1]").click(function() {
      var url = $(this).attr("href");
      var html5 = window.history && window.history.replaceState;

      if(html5){
        window.history.replaceState({}, document.title, url);

        $.get(url, function(data) {
          data = data.replace(/\n|\r/g, "");

          var m = data.match("<\s*title\s*>(.+)</\s*title\s*>");
          if(m && m[1]) {
            document.title = m[1];
          }

          m = data.match("<\s*body[^>]*>(.+)<\/\s*body\s*>");
          if(m && m[1]) {
            $("body").html(m[1]);
            initialize_all();
          } else {
            window.location = url;
          }
        });
      } else {
        window.location = url;
      }

      return false;
    })
  }
};
