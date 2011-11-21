class AskForm
  attr_accessor :view_context

  def initialize(view_context)
    @view_context = view_context
  end

  def action_url
    if question.new?
      view_context.questions_url
    else
      view_context.question_url(question)
    end
  end

  def geolocalization
    output = "".html_safe
    if question && question.position
      output << hidden_field_tag("question[position][lat]", @question.position["lat"], :class => "lat_input")
      output << hidden_field_tag("question[position][long]", @question.position["long"], :class => "long_input")
    end
    output
  end

  def tags_input
    adding_field do |f|
      f.text_field :tags, :value => @question.tags.join(", "), :class => "text_field autocomplete_for_tags"
    end
  end

  def description_input
    adding_field do |f|
      view_context.render "questions/editor", :f => f
    end
  end

  def attachments
    adding_field do |f|
      view_context.render "questions/attachment_editor", :f => f, :question => question
    end
  end

  def title_input
    adding_field do |f|
      f.text_field :title, :class => "text_area", :id => "question_title", :autocomplete => 'off'
    end
  end

  def language_input
    adding_field do |f|
      selected123 = @question.new? ? current_group.language : @question.language
      f.select :language, languages_options(known_languages(current_user, current_group)), {:selected => selected123}, {:class => "select"}
    end
  end

  def submit_button
    adding_field do |f|
      f.submit I18n.t("questions.index.ask_question", :default => :"layouts.application.ask_question"), :class => "ask_question"
    end
  end

  def anonymous_form
    view_context.render "users/anonymous_form"
  end

  def wiki_checkbox
    adding_field do |f|
      output = "".html_safe
      output << f.label(:wiki, "Wiki")
      output << f.check_box(:wiki)
      output
    end
  end

  def anonymous_checkbox
    adding_field do |f|
      output = "".html_safe
      output << f.label(:anonymous, t("scaffold.post_as_anonymous"))
      output << f.check_box(:anonymous, {:class => "checkbox"}, true, false)
      output
    end
  end

  protected
  def adding_field(&block)
    output = ""
    view_context.form_for([question, answer], :html => {:class => "add_answer markdown"}) do |f|
      output = block.call(f)
    end

    output
  end

  def question
    view_context.instance_variable_get(:@question) || Question.new
  end

  def method_missing(name, *args, &block)
    view_context.send(name, *args, &block)
  end
end
