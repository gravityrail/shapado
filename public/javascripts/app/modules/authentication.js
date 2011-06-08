var Auth = {
  initialize: function() {
    $('.auth-provider').click(function(){
      var authUrl = $(this).attr('href');
      $.cookie('pp', 1);
      var pparg;
      (authUrl.indexOf('?')==-1)? pparg = '?pp=1' : pparg = '&pp=1'
      window.open(authUrl+pparg, 'openid_popup', 'width=900,height=680');
      return false;
    });
  }
};