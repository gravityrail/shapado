var AnswerUI = {
  create_on_index: function(data) {
  },
  create_on_show: function(data) {
    $(".answers-list").prepend(data.html);
    $("article.answer."+data.object_id).effect("highlight", {}, 3000);
  },
  update_on_index: function(data) {

  },
  update_on_show: function(data) {
    $("article.answer."+data.object_id).html(data.html);
    $("article.answer."+data.object_id).effect("highlight", {}, 3000);
  }
}
