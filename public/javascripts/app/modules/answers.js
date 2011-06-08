var Answers = {
  create_on_index: function(data) {
  },
  create_on_show: function(data) {
    $(".answers-list").prepend(data.html);
    $("article.answer."+data.object_id).effect("highlight", {}, 3000);
    hideCommentsForm();
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
}
