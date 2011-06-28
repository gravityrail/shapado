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
  fix_html5_on_ie: function() {
    document.createElement('header');
    document.createElement('footer');
    document.createElement('section');
    document.createElement('aside');
    document.createElement('nav');
    document.createElement('article');
    document.createElement('hgroup');
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
  }
};
