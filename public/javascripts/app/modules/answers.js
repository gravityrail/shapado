var Answers = {
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
