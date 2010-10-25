$(document).ready(function() {
  if($('#groups_slug').length){
    $('#groups_slug').autocomplete({
      source: "/groups/autocomplete_for_group_slug.json",
      minLength: 1,
      select: function( event, ui ) {
          $('#groups_slug').val(ui.item.slug);
          return false;
      }
    })
    .data( "autocomplete" )._renderItem = function( ul, item ) {
      return $( "<li></li>" )
        .data( "item.autocomplete", item )
	.append( "<a>" + item.slug + "</a>" )
	.appendTo( ul );
    };
  }
})