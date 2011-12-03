module Layouts
  class ThemeLayoutView < ThemeViewBase
    def render_layout
      render_buffer current_theme.layout_html.read
    end

    # returns the content that will displayed inside of the layout
    # the content can be the list of question or a question and its answers
    def content
      view_context.content_for(:layout)
    end

    def default_stylesheets
      view_context.stylesheet_link_tag css_group_path(current_group, params[:test_theme] || current_theme.id, current_theme.version)
    end
  end
end
