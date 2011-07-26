// any initializing code from init_modernizer.js should go here for dev
$(document).ready(function() {
  Jqmath.initialize();
  var fields = $('.lang-fields');
  if(fields.length > 0){
    fields.tabs();
  }
  Effects.initialize();
  ShapadoSocket.initialize();
  $('.auto-link').autoVideo();
  $('.autocomplete_for_tags').ricodigoComplete();
  Form.initialize();
  Modernizr.load({
      test: $('meta[data-has-js]').length > 0,
      yep: $('meta[data-theme-js]').attr('data-theme-js')
    })
})