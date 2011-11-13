module Questions
  class Context
    attr_reader :question, :view_renderer
    alias :orig_respond_to? :respond_to?

    def initialize(question, view_renderer)
      @question = question
      @view_renderer = view_renderer
    end

    def title
      @question.title
    end

    def render_question
      view_renderer.render "questions/question", :question => @question
    end

    def respond_to?(method, priv = false)
      self.orig_respond_to?(method, priv) || @question.respond_to?(method, priv)
    end

    def method_missing(name, *args, &block)
      @question.send(name, *args, &block)
    end
  end
end
