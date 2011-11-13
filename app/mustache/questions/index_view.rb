module Questions
  class IndexView < ThemeViewBase
    def render_index
      render_buffer current_theme.questions_index_html.read
    end

    def foreach_question
      CollectionWrapper.new(@questions, QuestionWrapper, view_context)
    end

    def add_paginator
      paginate(@questions)
    end
  end
end
