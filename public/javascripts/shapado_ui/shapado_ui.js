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
  is_on_question_index: function() {
    return $("section.questions-index")[0] != null;
  },
  is_on_question_show: function() {
    return $("section.main-question#question")[0] != null;
  }
};


