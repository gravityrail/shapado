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
    if(authUrl.indexOf('{')!=-1){
      authUrl = '/users/login?open_id=1&url='+authUrl.split('=')[1]
    }
    (authUrl.indexOf('?')==-1)? pparg = '?pp=1' : pparg = '&pp=1'
    window.open(authUrl+pparg, 'openid_popup', 'width=700,height=500');
    $('#login_dialog').dialog('close');
  },
  startLoginDialog: function(title,join){
    var changed = $('#login_dialog').find('li a.login').attr('data-changed');
    console.log(changed)
    if(typeof(join)!='undefined' && changed != 1) {
      var newhref = $('li a.login').attr('data-href');
      var oldhref = $('li a.login').attr('href');

      $('#login_dialog').find('li a.login').attr({href: newhref, 'data-href': oldhref, 'data-changed': 1});
    }
    if(!title)
    var title = $('#login_dialog').attr('data-title');
    $('#login_dialog').dialog({title: title,
                             modal: true,
                             width: "150px",
                             resizable: false,
                             beforeClose:function(){
                               var changed = $('#login_dialog').find('li a.login').attr('data-changed');
                               if(changed==1)
                               $('#login_dialog').find('li a.login').attr({href: newhref,
                                                                           'data-href': oldhref, 'data-changed': 0});
                             }});
  }
};
