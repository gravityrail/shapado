$(document).ready(function() {

  var extraParams = Utils.url_vars();
  extraParams['format'] = 'js';

  $(".quick_question #ask_question").searcher({
    url : "/questions/related_questions.js",
    target : $(".questions-index"),
    fields : $(".quick_question #ask_question input#question_title"),
    behaviour : "live",
    timeout : 500,
    extraParams : extraParams,
    success: function(data) {
      $('#additional_info .pagination').html(data.pagination);
    }
  });

  $(".flag-link-index").live("click", function(event) {
    var link = $(this).parents("article.unanswered").find("h2 a");
    if(link) {
      window.location= link.attr("href")+"#to_flag"
    }
    return false;
  });
});
