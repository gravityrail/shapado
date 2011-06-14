var Questions = {
  initialize: function() {
    $("article.Question h3 a").click(function() {
      var l = $(this);
      var q = l.parents("article.Question");

      q.find(".question-body").slideToggle();

      return false;
    });
  }
};

$(document).ready(function() {
  Questions.initialize();
});
