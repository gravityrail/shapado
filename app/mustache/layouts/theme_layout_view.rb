module Layouts
  class ThemeLayoutView < ThemeViewBase
    def render_layout
      render_buffer current_theme.layout_html.read
    end

    def content
      view_context.content_for(:layout)
    end

    def default_stylesheets
      view_context.stylesheet_link_tag css_group_path(current_group, params[:test_theme] || current_theme.id, current_theme.version)
    end
  end
end