var Groups = {
  initialize: function($body) {
    if($body.hasClass("index")) {
      Groups.initialize_on_index($body);
    }
  },
  initialize_on_index: function($body) {
    $("#filter_groups").find("input[type=submit]").hide();

    $("#filter_groups").searcher({ url : "/groups.js",
                                target : $("#groups"),
                                behaviour : "live",
                                timeout : 500,
                                extraParams : { 'format' : 'js' },
                                success: function(data) {
                                  $('#additional_info .pagination').html(data.pagination);
                                }
    });
  }
}
