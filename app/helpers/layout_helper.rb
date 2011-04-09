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
end
