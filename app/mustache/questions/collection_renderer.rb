module Questions
  class CollectionRenderer < Enumerator
    attr_reader :questions, :view_renderer

    def initialize(questions, view_renderer)
      @questions = questions
      @view_renderer = view_renderer
    end

    def map(&block)
      @questions.map do |question|
        c = Questions::Context.new(question, view_renderer)

        block.call(c)
      end
    end
  end
end
