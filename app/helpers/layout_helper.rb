module LayoutHelper
  def tab_entry(element, text, path, options = {})
    options[:selected] ||= "selected"
    options[:link_opts] ||= {}

    html_opts = {}
    if request.path == path
      html_opts[:class] = options[:selected]
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
