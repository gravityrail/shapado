var Updater = {
  initialize: function() {
    var $main_content_wrap = $("#main-content-wrap");

    var current, prev, refreshed;
    Updater.setup_loading_icon();

    if($("section.questions-index").length > 0) {
      current = 'index';
    } else if($("section#main-question").length > 0) {
      current = 'question';
    }

    $("a.pjax-index, a.pjax-question").live("click", function(ev) {
      var link = $(this);

      prev = current;
      if(link.hasClass("pjax-question")) {
        current = 'question';
      } else {
        current = 'index';
      }

      var parent = link.parent();
      var gparent = parent.parent();

      if(gparent[0].tagName == "UL") {
        gparent.find("li").removeClass("active");
        parent.addClass("active");

        if(parent.hasClass("answers") || parent.hasClass("questions") || parent.hasClass("unanswered") || parent.hasClass("activity")) {
          $main_content_wrap.removeClass();
          $main_content_wrap.addClass(parent.attr("class"));
        }
      }

      var data = {_pjax: true};
      if(prev && prev != current){
        refreshed = data._refresh = true;
      }

      $.pjax({
        data: data,
        timeout: 10000,
        url: $(this).attr("href"),
        container: '#main-content-wrap',
        success: function(data) {
          if(refreshed) {
            Updater.setup_loading_icon();
            if(current == 'question') {
              Questions.initialize_on_show();
            }
          }

          return false;
        }
      });

      ev.preventDefault();

      return false;
    });
  },
  setup_loading_icon: function() {
    $("#main-content-wrap").bind('start.pjax', function() {
      var h = $( "<div class='loading-box'>" +
                 "<span class='loading-box-icon'></span>" +
                 "<h1>" + "Please wait.." + "</h1>" + "</div>" );

      $("body").prepend(h);
      h.css({
        top: $(window).scrollTop() + $(window).height() / 2
      });

      h.show();
    });

    $("#main-content-wrap").bind('end.pjax', function() {
      $(".loading-box").remove();
    });
  }
};
