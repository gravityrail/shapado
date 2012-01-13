var Tags = {
  initialize: function($body) {
    if($body.hasClass("index")) {
      Tags.initialize_on_index($body);
    }
  },
  initialize_on_index: function($body) {
    $("#filter_tags").find("input[type=submit]").hide();
    $("#filter_tags").searcher({ url : "/questions/tags.js",
                                target : $("#tag_table"),
                                behaviour : "live",
                                timeout : 500,
                                extraParams : { 'format' : 'js' },
                                success: function(data) { $('#tags').hide() }
    });
  }
};
