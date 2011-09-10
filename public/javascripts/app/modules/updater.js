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
      var current_page_layout = link.attr("data-page-layout");

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
        success: function(data, state, xhr) {
          var body = $(document.body);
          var body_class = xhr.getResponseHeader('x-bodyclass')
          if(current_page_layout)
            body_class += ' ' + current_page_layout
          body.attr({"class": body_class});
          Loader.refresh(body, refreshed);
          return false;
        }
      });

      ev.preventDefault();

      return false;
    });
  },
  guess_current_layout: function() {
    var layout = '';
    var page = $(document.body);

    if(page.hasClass('questions-controller index')) {
      layout = 'index';
    } else if(page.hasClass('questions-controller show')) {
      layout = 'question';
    } else if(page.hasClass('users-controller show')) {
      layout = 'user';
    } else if(page.hasClass('badges-controller')) {
      layout = 'badges';
    } else if(page.hasClass('pages-controller')) {
      layout = 'pages';
    } else if(page.hasClass('questions-controller new')) {
      layout = 'new-question';
    } else if(page.hasClass('admin-members-controller')) {
      layout = 'manage-members';
    } else if(page.hasClass('admin-announcements-controller')) {
      layout = 'manage-announcements';
    } else {
      layout = "index" // FIXME
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
