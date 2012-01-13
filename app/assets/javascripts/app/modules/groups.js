var Groups = {
  initialize: function($body) {
    if($body.hasClass("index")) {
      Groups.initialize_on_index($body);
    }
    if($body.hasClass("manage-layout")) {
      Groups.initialize_on_edit($body);
    }
  },  initialize_on_edit: function($body) {
      $('#group_enable_latex').change(function(){
        $('#group_enable_mathjax').removeAttr('checked')
      })
      $('#group_enable_mathjax').change(function(){
        $('#group_enable_latex').removeAttr('checked')
      })
  },
  initialize_on_manage_properties: function($body) {
    $('#group_language').chosen();
    $('#group_languages').chosen();
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
