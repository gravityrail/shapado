var Answers = {
  initialize: function($body) {
    if($body.hasClass("edit")) {
      Editor.setup($(".markdown_editor, .wysiwyg_editor"));
    } else if($body.hasClass("show")) {
      Votes.initialize_on_question();
      Comments.initialize_on_question();
    }
  },
  initialize_on_question: function() {
    var add_another_answer = $('#add_another_answer');
    if(add_another_answer.length > 0){
      var form = $('.add_answer');
      form.hide();
      add_another_answer.click(function() {
        add_another_answer.hide();
        form.show();
        return false;
      });
    }
  },
  create_on_index: function(data) {
  },
  create_on_show: function(data) {
    var is_there = $('.'+data.object_id).length;
    if(is_there==0){
      alert(is_there);
      $(".answers-list").prepend(data.html);
      $("article.answer."+data.object_id).effect("highlight", {}, 3000);
      Ui.hide_comments_form();
    }
  },
  update_on_index: function(data) {

  },
  update_on_show: function(data) {
    $("article.answer."+data.object_id).html(data.html);
    $("article.answer."+data.object_id).effect("highlight", {}, 3000);
  },
  vote: function(data) {
    $("article.answer."+data.object_id+" li.votes_average").text(data.average);
  }
};
