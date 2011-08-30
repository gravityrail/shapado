var Updater = {
  initialize: function() {
    var $main_content_wrap = $("#main-content-wrap");

    var current, prev, refreshed;
    Updater.setup_loading_icon();

    current = Updater.guess_current_layout();

    $(document.body).delegate("a.pjax", "click", function(ev) {
      var link = $(this);

      prev = current;
      current = link.attr("data-layout");

      var parent = link.parent();
      var gparent = parent.parent();

      if(gparent[0].tagName == "UL") {
        $(".widget-links ul li").removeClass('active');
        parent.addClass("active");

        if(parent.hasClass("answers") || parent.hasClass("questions") || parent.hasClass("unanswered") || parent.hasClass("activities")) {
          $main_content_wrap.removeClass();
          $main_content_wrap.addClass(parent.attr("class"));
        }
      }

      var data = {_pjax: true};

      if(prev && prev != current){
        refreshed = data._refresh = true;
      }

      // adsense is incompatible with pjax http://goo.gl/ieq2u
      // TODO remove this once adsense is compatible with html5 history
      if($('.widget-adsense').length > 0 && refreshed){
        return true;
      }

      $.pjax({
        data: data,
        timeout: 10000,
        url: $(this).attr("href"),
        container: '#main-content-wrap',
        success: function(data) {
          if(typeof(Effects) !== 'undefined'){
            Effects.initialize();
          }
          if(refreshed) {
            Updater.setup_loading_icon();
            if(current == 'question') {
              Questions.initialize_on_show();
            }
          }
          if(current == 'manage-announcements') {
            Editor.initialize();
          } else if(current == 'manage-members') {
            Members.initialize();
          } else if(current == 'manage-widgets') {
            Widgets.initialize();
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
    var pageClass = $('body').attr('class');

    if(pageClass.match(/questions-controller index/)) {
      layout = 'index';
    } else if(pageClass.match(/questions-controller show/)) {
      layout = 'question';
    } else if(pageClass.match(/users-controller show/)) {
      layout = 'user';
    } else if(pageClass.match(/badges-controller/)) {
      layout = 'badges';
    } else if(pageClass.match(/pages-controller/)) {
      layout = 'pages';
    } else if(pageClass.match(/questions-controller new/)) {
      layout = 'new-question';
    } else if(pageClass.match(/admin-members-controller/)) {
      layout = 'manage-members';
    } else if(pageClass.match(/admin-announcements-controller/)) {
      layout = 'manage-announcements';
    } else {
      layout = pageClass.split(' ')[0]
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
