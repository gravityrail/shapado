var Searches = {
  initialize: function($body) {
    $(".advanced-search").click(function(){
      $(".advanced-form").toggleClass("open").slideToggle("slow");
      return false;
    });
  }
}
