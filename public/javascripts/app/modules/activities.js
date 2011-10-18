var Activities = {
  initialize: function() {
  },
  create_on_index: function(data) {
    Utils.log("[create] activity");

    $.get('/activities/'+data.object_id, function(data) {
      $("ul.notifications-list li.notification").after("<li>"+data+"</li>");

      var counter = $("ul.notifications-list li:first a");
      counter.text(parseInt(counter.text())+1);
    });
  }
};