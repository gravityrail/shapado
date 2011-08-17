var Geo = {
  initialize: function() {
    $('#question_title').live('click', Geo.localize);
    $('body').delegate('#add_answer', 'hover', Geo.localize);
    $('#new_answer').live('hover', Geo.localize);
  },
  localize: function(){
      navigator.geolocation.getCurrentPosition(function(position){
          $('.lat_input').val(position.coords.latitude)
          $('.long_input').val(position.coords.longitude)
      }, function(){});
    }
};