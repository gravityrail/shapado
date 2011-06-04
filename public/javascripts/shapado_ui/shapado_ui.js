var ShapadoUI = {
  new_question: function(data) {
    if(ShapadoUI.is_on_question_index()){
      QuestionUI.create_on_index(data);
    } else if(ShapadoUI.is_on_question_show()) {
      QuestionUI.create_on_show(data);
    } else {
      // update widgets?
    }
  },
  update_question: function(data) {
    if(ShapadoUI.is_on_question_index()){
      QuestionUI.update_on_index(data);
    } else if(ShapadoUI.is_on_question_show()) {
      QuestionUI.update_on_show(data);
    } else {
      // update widgets?
    }
  },
  delete_question: function(data) {
    $("article.Question#"+data.object_id).fadeOut();
  },
  new_answer: function(data) {
    if(ShapadoUI.is_on_question_index()){
      AnswerUI.create_on_index(data);
    } else if(ShapadoUI.is_on_question_show()) {
      AnswerUI.create_on_show(data);
    }
  },
  update_answer: function(data) {
    if(ShapadoUI.is_on_question_index()){
      AnswerUI.update_on_index(data);
    } else if(ShapadoUI.is_on_question_show()) {
      AnswerUI.update_on_show(data);
    }
  },
  vote: function(data) {
    switch(data.on) {
      case 'Question': {
      }
      break;
      case 'Answer': {
        AnswerUI.vote(data);
      }
      break;
    }
  },
  is_on_question_index: function() {
    return $("section.questions-index")[0] != null;
  },
  is_on_question_show: function() {
    return $("section.main-question#question")[0] != null;
  }
};


