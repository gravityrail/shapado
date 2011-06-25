var Comments = {
  create_on_index: function(data) {
  },
  create_on_show: function(data) {
    var comment = $('#'+data.object_id);
    if(comment.length==0){
      var commentable = $('.'+data.commentable_id);
      var comments = commentable.find('.comments');
      comments.append(data.html);
      Effects.fade(comment);
    }
  },
  update_on_index: function(data) {

  },
  update_on_show: function(data) {
  },
  vote: function(data) {
  }
}
