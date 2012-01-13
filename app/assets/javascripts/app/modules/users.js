var Users = {
  initialize: function($body) {
    if($body.hasClass("index")) {
      Users.initialize_on_index($body);
    } else if($body.hasClass("edit")) {
      Networks.initialize($body);
    }
  },
  initialize_on_edit: function($body) {
    if($body.hasClass("index")) {
      Users.initialize_on_index($body);
    } else if($body.hasClass("edit")) {
      Networks.initialize($body);
    }
  },
  initialize_on_index: function($body) {
    $("#filter_users input[type=submit]").remove();

    $("#filter_users").searcher({ url : "/users.js",
                                target : $("#users"),
                                behaviour : "live",
                                timeout : 500,
                                extraParams : { 'format' : 'js' },
                                success: function(data) {
                                  $('#additional_info .pagination').html(data.pagination)
                                }
    });
  },
  initialize_on_show: function($body) {
    $('#user_language').chosen();
    $('#user_timezone').chosen();
    $('#user_preferred_languages').chosen();
  }
}
