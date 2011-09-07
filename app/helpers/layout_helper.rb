module LayoutHelper
  def tab_entry(element, text, path, options = {}, html_opts = {})
    options[:selected] ||= "selected"
    options[:link_opts] ||= {}

    if request.path == path
      if html_opts[:class]
        html_opts[:class] = "#{html_opts[:class]} #{options[:selected]}"
      else
        html_opts[:class] = options[:selected]
      end
    end

    if element != "a"
      content_tag(element, html_opts) do
        link_to(text, path, options[:link_opts])
      end
    else
      link_to text, path, html_opts.merge(options[:link_opts])
    end
  end

  def pjax_tab_entry(element, text, layout, path, options = {}, html_opts = {})
    link_opts = options[:link_opts] || {}
    if link_opts[:class].nil? || !(link_opts[:class] =~ /pjax/)

      link_opts[:class] = "#{link_opts[:class]} pjax"
    end

    link_opts.merge!(:"data-layout" => layout)
    options[:link_opts] = link_opts

    tab_entry(element, text, path, options, html_opts)
  end

  def pjax_link_to(text, layout, path, options = {})
    klass = "pjax"
    if extra_class = options.delete(:class) || options.delete('class')
      klass << " " << extra_class
    end

    link_to text, path, options.merge(:class => klass, :"data-layout" => layout)
  end

  def render_app_config
    content_tag(:span, "", {:id=>"appconfig",:"data-g"=>current_group.id})
  end

  def questions_link_for(action)
    case action
    when "by_me"
      {"controller" => "users", "action" => "by_me", :id => current_user.to_param}
    when "feed"
      {"controller" => "users", "action" => "feed", :id => current_user.to_param}
    when "preferred"
      {"controller" => "users", "action" => "preferred", :id => current_user.to_param}
    when "expertise"
      {"controller" => "users", "action" => "expertise", :id => current_user.to_param}
    when "contributed"
      {"controller" => "users", "action" => "contributed", :id => current_user.to_param}
    else
      {"controller" => "questions", "action" => "index"}
    end
  end
end
