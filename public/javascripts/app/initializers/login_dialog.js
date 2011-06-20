function startLoginDialog(){
  var title = $('#login_dialog').attr('data-title');
  $('#login_dialog').dialog({title: title,
                             modal: true,
                             width: "150px",
                             resizable: false});
}