var Auth = {
  initialize: function() {
    $('.auth-provider').live("click", function(){
      var authUrl = $(this).attr('href');

      Auth.open_popup(authUrl);

      return false;
    });
  },
  position_dropdown: function(){
    if(Ui.offline()){
      $('.providers-list').show().offset({left: $('.offline').offset().left+$('.offline').width()-$('.providers-list').width()}).hide();
        //$('.providers-list').show().offset({left: $('body').width()/2-$('#column2').width()/2}).css({width: '290px'});
    }
  },
  dropdown_toggle: function(){
    $('[data-toggle-dropdown]').click(function(){
      var toggleClass = $(this).data('toggle-dropdown');
      $('.dropdown-form').addClass('hidden');
      var toggleEle = $('.'+toggleClass).toggleClass('hidden');
      Auth.position_dropdown();
      $('.providers-list').show();
      return false;
    })
    }
  ,
  open_popup: function(authUrl) {

    var pparg;
    if(authUrl.indexOf('{')!=-1){
      authUrl = authUrl.split('=')[1];
      $('[data-toggle-dropdown=dropdown-signin-openid]').trigger('click');
      $('#openid_url').val(authUrl);
      return false;
    } else {
      $.cookie('pp', 1);
      (authUrl.indexOf('?')==-1)? pparg = '?pp=1' : pparg = '&pp=1'
      window.open(authUrl+pparg, 'openid_popup', 'width=700,height=500');
      $('#login_dialog').dialog('close');
    }
  },
  startLoginDialog: function(title,join){
    if(Ui.not_member()){
        var title = $('#join_dialog').attr('data-title');
        $('#join_dialog').dialog({title: title, modal: true, resizable: false})
    } else {
        $('.offline li:first').trigger('click');
        Messages.show($('.offline').data('signin-notice'), 'error', 5000 );
        return false;
    }
  }
};
