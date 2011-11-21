module Questions
  class IndexView < ThemeViewBase
    def render_index
      render_buffer current_theme.questions_index_html.read
    end

    def foreach_question
      CollectionWrapper.new(@questions, QuestionWrapper, view_context)
    end

    def paginate_questions
      paginate(@questions)
    end
    alias :add_paginator :paginate_questions
  end
end
