$(document).ready(function() {
  $("a#add_reward, a#add_question_comment, a#add_answer").click(function(event) {
    var link = $(this);
    var toolbar = link.parents("ul");
    var id = link.attr("id");

    var form = $("#panel-forms form."+id);

    $("#panel-forms form").slideUp();

    form.slideToggle("slow");//
    toolbar.find("li a").removeClass("active");
    link.addClass("active");

    return false;
  });
});

