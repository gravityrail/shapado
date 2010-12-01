$(document).ready(function() {
  $("a#add_reward, a#add_question_comment, a#add_answer").click(function(event) {
    var link = $(this);
    var id = link.attr("id");
    var form = $("#panel-forms form."+id);

    if(link.hasClass("active")){
      link.removeClass("active");
      form.slideUp();
      return false;
    }

    var toolbar = link.parents("ul");
    $("#panel-forms form").slideUp();

    form.slideToggle("slow");//
    toolbar.find("li a").removeClass("active");
    link.addClass("active");

    return false;
  });

  $("#panel-forms form a.cancel").click(function(event) {
    $(this).parents('form').slideUp();
    $(".toolbar ul li a").removeClass("active");
    return false;
  });
});

