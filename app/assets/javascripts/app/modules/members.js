var Members = {
  initialize: function(data) {
    $("#filter_members").searcher({ url : "/manage/members.js",
                              target : $("#members"),
                              behaviour : "live",
                              timeout : 500,
                              extraParams : { 'format' : 'js' },
                              success: function(data) {
                                $('.pagination').html(data.pagination)
                              }
    });
    $('.filter_input').hide();
  }
}
