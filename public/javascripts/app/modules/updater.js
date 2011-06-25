var Updater = {
  initialize: function() {
    var $main_content_wrap = $("#main-content-wrap");

    Updater.setup_loading_icon();

    $("a.pjax").live("click", function(ev) {
      var link = $(this);
      var section = link.attr("data-section");

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

      $.pjax({
        timeout: 7000,
        url: $(this).attr("href"),
        container: '#main-content-wrap',
        success: function() {
          if(section == "question") {
            alert("run js to setup the question view");
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
