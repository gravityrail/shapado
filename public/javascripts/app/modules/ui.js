var Ui = {
  initialize: function() {
     var languages_filter = $(".languages_filter form")
      languages_filter.find(".buttons").hide();
      languages_filter.find("#language_filter").change(function(){
      submit = languages_filter.find(".buttons .change_language");
      submit.trigger("click");
    });

    $('ul.sf-menu').superfish();

    //$('.lang-fields').tabs();

    Ui.hide_comments_form();
    //Ui.initialize_feedback();

    //$('.autocomplete_for_tags').ricodigoComplete();
    $('#quick_question').find('.tagwrapper').css({'margin-left':'18px',width:'68%'});

    if(Ui.supports_input_placeholder()) {
      $('.hideifplaceholder').remove();
    };

    $('.langbox.jshide').hide();
    $('.show-more-lang').click(function(){
        $('.langbox.jshide').toggle();
        return false;
    });

    Ui.sort_values('#group_language', 'option', ':last', 'text', null);
    Ui.sort_values('#user_language', 'option',  false, 'text', null);
    Ui.sort_values('#lang_opts', '.radio_option', false, 'attr', 'id');
    Ui.sort_values('select#question_language', 'option', false, 'text', null);

    $(document.body).delegate(".toggle-action", "click", function(event) {
      if(Ui.offline()){
        startLoginDialog();
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
      return false;
    });
  },
  hide_comments_form: function() {
    $("form.nestedAnswerForm").hide();
  },
  initialize_feedback: function() {
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
  },
  supports_input_placeholder: function() {
    var i = document.createElement('input');
    return 'placeholder' in i;
  },
  sort_values: function(selectID, child, keepers, method, arg) {
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
  },
  offline: function(){
    return $('.offline').length>0
  },
  center_scroll: function(tag, container){
    container = container || $('html,body');
    viewportHeight = $(window).height();
    if(window.innerHeight)
      viewportHeight = window.innerHeight;

    var top = tag.offset().top - viewportHeight/2.0;

    container.scrollTop(top);
  },
  navigate_shortcuts: function(container, element_selector){
    elements = container.find(element_selector);
    var first_element = elements[0];
    if(first_element) {
      $(first_element).addClass("active");
    }

    container.delegate(element_selector, "click", function(ev) {
      elements.removeClass("active");
      next = $(this);
      next.addClass("active");
      Ui.center_scroll(next);
    });

    $(document).keydown(function(ev){
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
    });
  }
};
