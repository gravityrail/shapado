module Questions
  class ShowView < ThemeViewBase
    attr_reader :wrapper
    alias :orig_respond_to? :respond_to?

    def initialize(*args)
      super(*args)
      @wrapper = QuestionWrapper.new(@question, view_context)

      @wrapper.public_methods(false).each do |m|
        method = m.to_s
        next if ['respond_to?', 'method_missing'].include?(method)
        class << self; self; end.instance_eval do
          define_method(method) do |*args|
            @wrapper.send(method, *args)
          end
        end
      end
    end

    def render_show_page
      render_buffer current_theme.questions_show_html.read
    end

    def respond_to?(method, priv = false)
      self.orig_respond_to?(method, priv) || @wrapper.respond_to?(method, priv)
    end

    def method_missing(name, *args, &block)
      if @wrapper.respond_to?(name)
        @wrapper.send(name, *args, &block)
      else
        super(name, *args, &block)
      end
    end
  end
end
