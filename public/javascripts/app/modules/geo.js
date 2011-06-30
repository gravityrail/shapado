var Geo = {
  initialize: function() {
    $('textarea, #question_title').live('focus', function(){
      navigator.geolocation.getCurrentPosition(function(position){
          $('.lat_input').val(position.coords.latitude)
          $('.long_input').val(position.coords.longitude)
      }, function(){});
    });
  }
};