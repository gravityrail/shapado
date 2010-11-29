
$(document).ready(function() {
  $("label#rqlabel").hide();

  $(".text_field#question_title").focus( function() {
    highlightEffect($("#sidebar .help"))
  });

  $("#ask_question").searcher({ url : "/questions/related_questions.js",
                              target : $("#related_questions"),
                              fields : $("input[type=text][name*=question]"),
                              behaviour : "focusout",
                              timeout : 2500,
                              extraParams : { 'format' : 'js', 'per_page' : 5 },
                              success: function(data) {
                                $("label#rqlabel").show();
                              }
  });

  $("#ask_question").bind("keypress", function(e) {
    if (e.keyCode == 13) {
       return false;
     }
  });

  var fields = $("#attachments #fields");
  var template = fields.find(".template");
  template.hide();
  template.attr("name", "attachments[id]");

  $("#attachments #fields .attachment_field .remove_attachment").live("click", function(e) {
    $(this).parent().remove();
    return false;
  });

  var count = -1;
  $("#attachments .add_attachment").live("click", function(e) {
    var template = fields.find(".template");
    var new_field = template.clone();
    new_field.removeClass("template");
    count++;
    var new_name = new_field.find("input").attr("name").replace(/(id)/, count);
    new_field.find("input").attr("name",new_name)

    new_field.show();

    fields.append(new_field);

    return false;
  });

});
