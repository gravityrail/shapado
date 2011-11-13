module Questions
  class Context < ModelWrapper
    def render_question
      view_context.render "questions/question", :question => @target
    end

    def url
      view_context.question_url(@target)
    end

    def truncated_description
      view_context.truncate(@target.body, :length => 200)
    end

    def foreach_tag
      current_group.tags.where(:name.in => @target.tags).map{|tag| TagWrapper.new(tag, view_context) }
    end

    def respond_to?(method, priv = false)
      self.orig_respond_to?(method, priv) || @target.respond_to?(method, priv)
    end

    def method_missing(name, *args, &block)
      @target.send(name, *args, &block)
    end
  end
end
