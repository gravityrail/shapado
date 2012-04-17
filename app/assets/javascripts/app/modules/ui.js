Ui = function() {
  var self = this;

  function initialize() {
    if(typeof(Effects) !== 'undefined'){
      Effects.initialize();
    }
    var quick_question = $('.quick_question');
    quick_question.find('.buttons-quickq').hide();
    quick_question.find('form input[type=text]').focus(function(){
      quick_question.find('.buttons-quickq').show();
    });

    Auth.dropdownToggle();
    Auth.positionDropdown();
    Ui.initializeAjaxTooltips();
    Ui.initializeSmoothScrollToTop();
    if(Ui.supportsInputPlaceholder()) {
      $('.hideifplaceholder').remove();
    };

    $('.langbox.jshide').hide();
    $('.show-more-lang').click(function(){
        $('.langbox.jshide').toggle();
        return false;
    });

    if(Questions.isIndexEmpty()){
      var current_language = $('.current_language > a').data('language');
      if(current_language!='any'){
        $('.current_language').tipsy({trigger: 'manual', gravity: 'w'});
        $('.current_language').tipsy('show');
      }
    }
    $('[rel=tipsy]').tipsy({gravity: 's'});
    $('.lang-option').click(function(){
      var path = $('#lang-select-toggle').data('language');
      var language = $(this).data('language');
      $.ajax({type: 'POST', url: path,
              data: {'language[filter]': language},
              success: function(){window.location.reload()}
             });
    });

    $('#openid_url').parents('form').submit(function(){
      var openid = $('#openid_url').val();
      openid = openid.replace('http://','');
      openid = openid.replace('https://','');
      $('#openid_url').val(openid)
    })

    Ui.sortValues('#group_language', 'option', ':last', 'text', null);
    Ui.sortValues('#user_language', 'option',  false, 'text', null);
    Ui.sortValues('#lang_opts', '.radio_option', false, 'attr', 'id');
    Ui.sortValues('select#question_language', 'option', false, 'text', null);

    //TODO: delegate is deprecated use on
    $(document.body).delegate("#ask_question", "submit", function(event) {
        if(Ui.offline()){
            Auth.startLoginDialog();
            return false;
        }
    });
    //TODO: delegate is deprecated use on
    $(document.body).delegate("#join_dialog_link", "click", function(event) {
      Groups.join(this);
      return false;
    });
    //TODO: delegate is deprecated use on
    $(document.body).delegate(".join_group", "click", function(event) {
      if(!$(this).hasClass('email')){
        Auth.startLoginDialog($(this).text(),1);
        return false;
      } else {document.location=$(this).attr('href')}
    });
    //TODO: delegate is deprecated use on
    $(document.body).delegate(".toggle-action,.not_member", "click", function(event) {
      if(Ui.offline()){
        Auth.startLoginDialog();
      } else {
        var link = $(this);
        if(!link.hasClass('busy')){
          link.addClass('busy');
          var href = link.attr("href");
          var dataUndo = link.attr("data-undo");
          var title = link.attr("title");
          var dataTitle = link.attr("data-title");
          var img = link.children('img');
          var counter = $(link.attr('data-counter'));
          var text = link.text();
          var dataText = link.attr("data-text");
          var dataMethod = link.attr("data-method");
          var csrf = $('meta[name="csrf-token"]').attr('content');
          if(dataMethod == 'post'){
            $.ajax({url: href, headers:{'X-CSRF-Token': csrf}, data: {'authenticity_token': csrf}, dataType: "json", type: "post", success: function(data){
              if(data.success){
                link.attr({href: dataUndo, 'data-undo': href, title: dataTitle, 'data-title': title, 'data-text': text });
                if(dataText && $.trim(dataText)!='')
                  link.text(dataText);
                img.attr({src: img.attr('data-src'), 'data-src': img.attr('src')});
                if(typeof(data.increment)!='undefined'){
                  counter.text(parseFloat($.trim(counter.text()))+data.increment);
                }
                Messages.show(data.message, "notice");
              } else {
                Messages.show(data.message, "error");

                if(data.status == "unauthenticate") {
                  window.onbeforeunload = null;
                  window.location="/users/login";
                }
              }
              link.removeClass('busy');
            }});
          } else {
            $.getJSON(href, {format: "js"}, function(data){
              if(data.success){
                link.attr({href: dataUndo, 'data-undo': href, title: dataTitle, 'data-title': title, 'data-text': text });
                if(dataText && $.trim(dataText)!='')
                  link.text(dataText);
                img.attr({src: img.attr('data-src'), 'data-src': img.attr('src')});
                if(typeof(data.increment)!='undefined'){
                  counter.text(parseFloat($.trim(counter.text()))+data.increment);
                }
                Messages.show(data.message, "notice");
              } else {
                Messages.show(data.message, "error");

                if(data.status == "unauthenticate") {
                  window.onbeforeunload = null;
                  window.location="/users/login";
                }
              }
              link.removeClass('busy');
            }, "json");
          }
        }
      }
      return false;
    });
    Form.initialize();
  }

  function initializeFeedback() {
    $("#feedbackform").dialog({ title: "Feedback", autoOpen: false, modal: true, width:"420px" });
    $('#feedbackform .cancel-feedback').click(function(){
      $("#feedbackform").dialog('close');
      return false;
    });
    $('#feedback').click(function(){
      var isOpen = $("#feedbackform").dialog('isOpen');
      if (isOpen){
        $("#feedbackform").dialog('close');
      } else {
        $("#feedbackform").dialog('open');
      }
      return false;
    });
  }

  function supportsInputPlaceholder() {
    var i = document.createElement('input');
    return 'placeholder' in i;
  }

  function sortValues(selectID, child, keepers, method, arg) {
    if(keepers){
      var any = $(selectID+' '+child+keepers);
      any.remove();
    }
    var sortedVals = $.makeArray($(selectID+' '+child)).sort(function(a,b){
      return $(a)[method](arg) > $(b)[method](arg) ? 1: -1;
    });
    $(selectID).html(sortedVals);
    if(keepers)
      $(selectID).prepend(any);
    // needed for firefox:
    $(selectID).val($(selectID+' '+child+'[selected=selected]').val());
  }

  function offline() {
    return $('.offline').length>0 || notMember();
  }

  function notMember() {
    return $('.not_member').length>0;
  }

  function centerScroll(tag, container) {
    container = container || $('html,body');
    viewportHeight = $(window).height();
    if(window.innerHeight)
      viewportHeight = window.innerHeight;

    var top = tag.offset().top - (viewportHeight/2.0);

    container.scrollTop(top);
  }

  function navigateShortcuts(container, element_selector) {
    elements = container.find(element_selector);
    var first_element = elements[0];
    if(first_element) {
      $(first_element).addClass("active");
    }

    container.delegate(element_selector, "click", function(ev) {
      elements.removeClass("active");
      next = $(this);
      next.addClass("active");
    });

    $(document).keydown(function(ev) {

      if(container.is(':visible')) {
        current_element = $(container.find(element_selector+'.active'));

        moved = false;
        next = null;
        if(ev.keyCode == 74){
          next = current_element.next(element_selector);
        } else if(ev.keyCode == 75){
          next = current_element.prev(element_selector);
        }

        if(next && next.length > 0) {
          current_element.removeClass("active");
          next.addClass("active");
          Ui.center_scroll(next);
        }
      }
    });
  }

  function initializeLangFields(container) {
    var fields = (container||$('body')).find('.lang-fields');
    if(fields.length > 0){
      fields.tabs();
    }
  }

  function initializeSmoothScrollToTop() {
    $(".top-bar").click(function(e) {
      var isTopBar = $(e.target).hasClass('top-bar');
      if(isTopBar)
        $("html, body").animate({ scrollTop: 0 }, "fast");
    });
  }

  function initializeAjaxTooltips() {
    $(document.body).on("mouseleave, scroll",".markdown, .toolbar, .Question, .comment-content, .tag-list, .user-data, .tooltip", function(event) {
      $(".tooltip").hide();
    });

    $(document.body).on("mouseenter", ".toolbar, .markdown, .Question, .comment-content, .tag-list, .user-data", function(event) {
      $(".tooltip").hide();
    });

    $(document.body).on("hover", ".ajax-tooltip", function(event) {
      var url = $(this).attr('href');
      var tag_link = $(this);
      $('.tooltip').hide();
      if(tag_link.data('tooltip')==1){
        var tooltip = tag_link.next('.tooltip');
        tooltip.show(); //.delay(1800).fadeIn(400).delay(1800);
        return false;
      }
      $.ajax({
        url: url+'?tooltip=1',
        dataType: 'json',
        success: function(data){
          $(".tooltip").hide();
          tag_link.removeAttr('title');
          tag_link.data('tooltip', 1);
          tag_link.after(data.html)
          var tooltip = tag_link.next('.tooltip');
          tooltip.css({'display': 'block'});
          tooltip.position({at: 'top center', of: tag_link, my: 'bottom', collision: 'fit fit'})
        }})
      return false;
    })

  }

  return {
    initialize:initialize,
    initializeFeedback:initializeFeedback,
    supportsInputPlaceholder:supportsInputPlaceholder,
    sortValues:sortValues,
    offline:offline,
    notMember:notMember,
    centerScroll:centerScroll,
    navigateShortcuts:navigateShortcuts,
    initializeLangFields:initializeLangFields,
    initializeSmoothScrollToTop:initializeSmoothScrollToTop,
    initializeAjaxTooltips:initializeAjaxTooltips
  }
}();
