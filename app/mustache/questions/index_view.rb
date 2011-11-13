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

    protected
    def current_group
      view_context.current_group
    end

    def current_theme
      @current_theme ||= current_group.current_theme
    end
  end
end
