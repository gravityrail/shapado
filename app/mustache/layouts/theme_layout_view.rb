module Layouts
  class ThemeLayoutView < ThemeViewBase
    def render_layout
      render_buffer current_theme.layout_html.read
    end

    def content
      view_context.content_for(:layout)
    end
  end
end