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


  $(".question-action").live("click", function(event) {
    if(Ui.offline()){
      startLoginDialog();
    } else {
      var link = $(this);
      if(!link.hasClass('busy')){
        link.addClass('busy');
        var href = link.attr("href");
        var dataUndo = link.attr("data-undo");
        var title = link.attr("title");
        var dataTitle = link.attr("data-title");
        var img = link.children('img');
        var counter = $(link.attr('data-counter'));
        var text = link.text();
        var dataText = link.attr("data-text");

        $.getJSON(href+'.js', function(data){
          if(data.success){
            link.attr({href: dataUndo, 'data-undo': href, title: dataTitle, 'data-title': title, 'data-text': text });
            if(dataText && $.trim(dataText)!='')
              link.text(dataText);
            img.attr({src: img.attr('data-src'), 'data-src': img.attr('src')});
            if(typeof(data.increment)!='undefined'){
              counter.text(parseFloat($.trim(counter.text()))+data.increment);
            }
            Messages.show(data.message, "notice");
          } else {
            Messages.show(data.message, "error");

            if(data.status == "unauthenticate") {
              window.onbeforeunload = null;
              window.location="/users/login";
            }
          }
          link.removeClass('busy');
          }, "json");
        }
    }
    return false;
  });
});
