var ShapadoUI = {
  new_question: function(data) {
    if(ShapadoUI.is_on_question_index()){
      Questions.create_on_index(data);
    } else if(ShapadoUI.is_on_question_show()) {
      Questions.create_on_show(data);
    } else {
      // update widgets?
    }
  },
  update_question: function(data) {
    if(ShapadoUI.is_on_question_index()){
      Questions.update_on_index(data);
    } else if(ShapadoUI.is_on_question_show()) {
      Questions.update_on_show(data);
    } else {
      // update widgets?
    }
  },
  delete_question: function(data) {
    $("article.Question#"+data.object_id).fadeOut();
  },
  new_answer: function(data) {
    if(ShapadoUI.is_on_question_index()){
      Answers.create_on_index(data);
    } else if(ShapadoUI.is_on_question_show()) {
      Answers.create_on_show(data);
    }
  },
  update_answer: function(data) {
    if(ShapadoUI.is_on_question_index()){
      Answers.update_on_index(data);
    } else if(ShapadoUI.is_on_question_show()) {
      Answers.update_on_show(data);
    }
  },
  new_comment: function(data) {
    if(ShapadoUI.is_on_question_show()) {
      Comments.create_on_show(data);
    }
  },
  update_comment: function(data) {
    if(ShapadoUI.is_on_question_show()) {
      Comments.update_on_show(data);
    }
  },
  vote: function(data) {
    switch(data.on) {
      case 'Question': {
      }
      break;
      case 'Answer': {
        Answers.vote(data);
      }
      break;
    }
  },
  new_activity: function(data) {
    Activities.create_on_index(data);
  },
  is_on_question_index: function() {
    return $("section.questions-index")[0] != null;
  },
  is_on_question_show: function() {
    return $("section.main-question#question")[0] != null;
  }
};


