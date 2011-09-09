$(document).ready(function() {
  var $body = $(document.body);
  Uploader.initialize($body, true);
});

$(document).ready(function(){
  $(".advanced-search").click(function(){
    $(".advanced-form").toggleClass("open").slideToggle("slow");
      return false;
    });
});
