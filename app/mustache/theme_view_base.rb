class ThemeViewBase < Poirot::View
  def add_ask_question_box
    view_context.render
  end

  def foreach_recent_tag
    CollectionWrapper.new(current_group.tags.desc(:used_at).limit(50), TagWrapper, view_context)
  end

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

  def current_group
    view_context.current_group
  end
end
