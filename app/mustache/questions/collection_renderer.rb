module Questions
  class CollectionRenderer < Enumerator
    attr_reader :questions, :view_context

    def initialize(questions, view_context)
      @questions = questions
      @view_context = view_context
    end

    def map(&block)
      @questions.map do |question|
        c = Questions::Context.new(question, view_context)

        block.call(c)
      end
    end
  end
end
