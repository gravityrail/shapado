var Geo = {
  initialize: function() {
    $(document.body).delegate('#question_title', 'click', Geo.localize);
    $(document.body).delegate('#add_answer', 'hover', Geo.localize);
    $(document.body).delegate('#new_answer', 'hover', Geo.localize);
  },
  localize: function(){
    if($('.lat_input').val()==0.0 || $('.long_input').val()==0.0){
      navigator.geolocation.getCurrentPosition(function(position){
        $('.lat_input').val(position.coords.latitude)
        $('.long_input').val(position.coords.longitude)
      }, function(){console.log('NO')});
    }
  }
};
