$(document).ready(function() {
  $("a#add_reward, a#add_question_comment, a#add_answer, a#share_question, a#flag_question, a#request-close-link").click(function(event) {
    var link = $(this);
    var id = link.attr("id");
    var lazy = link.attr("data-lazy") == "1";

    var form = $("#panel-forms ."+id);

    if(link.hasClass("active")){
      link.removeClass("active");
      form.slideUp();
      return false;
    }

    var toolbar = link.parents("ul");
    $("#panel-forms form").slideUp();

    if(lazy && form.length < 1) {
      var href = link.attr('href');
      if(!link.hasClass('busy')){
        link.addClass('busy');
        $.getJSON(href+'.js', function(data){
          var nform = $(data.html);
          $("#panel-forms").prepend(nform);
          nform.slideDown("slow");
          link.removeClass('busy');
          toolbar.find("li a").removeClass("active");
          link.addClass("active");
        });
      }
    } else {
      form.slideDown("slow");
      toolbar.find("li a").removeClass("active");
      link.addClass("active");
    }

    return false;
  });

  $("#panel-forms form a.cancel").click(function(event) {
    $(this).parents('form').slideUp();
    $(".toolbar ul li a").removeClass("active");
    return false;
  });
});

