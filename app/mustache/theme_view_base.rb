class ThemeViewBase < Poirot::View
  def add_header_widgets
    view_context.render "shared/widgets", :context => 'mainlist', :position => 'header'
  end

  def add_footer_widgets
    view_context.render "shared/widgets", :context => 'mainlist', :position => 'footer'
  end

  def add_navbar_widgets
    view_context.render "shared/widgets", :context => 'mainlist', :position => 'navbar'
  end

  def add_sidebar_widgets
    view_context.render "shared/widgets", :context => 'mainlist', :position => 'sidebar'
  end
end
