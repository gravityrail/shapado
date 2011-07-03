var Updater = {
  initialize: function() {
    var $main_content_wrap = $("#main-content-wrap");

    var current, prev, refreshed;
    Updater.setup_loading_icon();

    current = Updater.guess_current_layout();

    $("a.pjax").live("click", function(ev) {
      var link = $(this);

      prev = current;
      current = link.attr("data-layout");

      var parent = link.parent();
      var gparent = parent.parent();

      if(gparent[0].tagName == "UL") {
        $(".widget-links ul li").removeClass('active');
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
  guess_current_layout: function() {
    var layout = '';
    if($("section.questions-index").length > 0) {
      layout = 'index';
    } else if($("section#main-question").length > 0) {
      layout = 'question';
    } else if($('#users_show').length > 0) {
      layout = 'user';
    } else if($('#badges_show, #badges').length > 0) {
      layout = 'badges';
    } else if($('#pages_show, #pages').length > 0) {
      layout = 'pages';
    } else if($('.ask_question').length > 0) {
      layout = 'new-question';
    }

    return layout;
  },
  setup_loading_icon: function() {
    var text = 'Loading...';
    if(typeof I18n.loading !== 'undefined'){
      text = I18n.loading;
    }

    $("#main-content-wrap").bind('start.pjax', function() {
      var h = $( "<div class='loading-box'>" +
                 "<span class='loading-box-icon'></span>" +
                 "<h1>" + text + "</h1>" + "</div>" );

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
