class AnswerForm
  attr_accessor :view_context

  def initialize(view_context)
    @view_context = view_context
  end

  def render_default
    view_context.render "answers/form"
  end

  def editor
    adding_field do |f|
      view_context.render 'answers/editor', :f => f
    end
  end

  def action_url
    view_context.url_for([question, answer])
  end

  def author_name_input
    adding_user_field do |f|
      f.text_field :name
    end
  end

  def author_email_input
    adding_user_field do |f|
      f.text_field :email
    end
  end

  def author_website_input
    adding_user_field do |f|
      f.text_field :website
    end
  end

  def recaptcha
    if AppConfig.recaptcha["activate"]
      recaptcha_tag(:challenge, :width => 600, :rows => 5, :display => {:lang => I18n.locale}).html_safe
    end
  end

  def wiki_checkbox
    adding_field do |f|
      f.check_box :wiki, :class => "checkbox"
    end
  end

  def anonymous_checkbox
    adding_field do |f|
      f.check_box :anonymous, :class => "checkbox"
    end
  end

  def if_anonymous
    !is_bot? && !user_signed_in? && current_group.enable_anonymous
  end

  def if_not_logged_in
    !logged_in?
  end

  def if_logged_in
    logged_in?
  end

  protected
  def adding_field(&block)
    output = ""
    view_context.form_for([question, answer], :html => {:class => "add_answer markdown"}) do |f|
      output = block.call(f)
    end

    output
  end

  def adding_user_field(&block)
    output = ""
    view_context.fields_for :user do |f|
      output = block.call(f)
    end
    output
  end

  def question
    view_context.instance_variable_get(:@question)
  end

  def answer
    view_context.instance_variable_get(:@answer) || Answer.new
  end

  def method_missing(name, *args, &block)
    view_context.send(name, *args, &block)
  end
end
