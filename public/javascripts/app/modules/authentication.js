var Auth = {
  initialize: function() {
    $('.auth-provider').live("click", function(){
      var authUrl = $(this).attr('href');

      Auth.open_popup(authUrl);

      return false;
    });
  },
  open_popup: function(authUrl) {
    $.cookie('pp', 1);
    var pparg;
    (authUrl.indexOf('?')==-1)? pparg = '?pp=1' : pparg = '&pp=1'
    window.open(authUrl+pparg, 'openid_popup', 'width=700,height=500');
    $('#login_dialog').dialog('close');
  }
};
