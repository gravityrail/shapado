$(document).ready(function() {
  if($('#member_user_id').length){
    $('#member_user_id').autocomplete({
      source: "/users/autocomplete_for_user_login.json",
      minLength: 1,
      select: function( event, ui ) {
          $( '#member_user_id' ).val(ui.item.login);
          return false;
      }
    })
    .data("autocomplete")._renderItem = function( ul, item ) {
      return $( "<li></li>" )
        .data( "item.autocomplete", item )
	.append( "<a>" + item.login + "</a>" )
	.appendTo( ul );
    };
  }
})
