class ThemeViewBase < Poirot::View
  def initialize(*args)
    super(*args)
  end

  def add_ask_question_box
    view_context.render
  end

  def foreach_recent_tag
    CollectionWrapper.new(current_group.tags.desc(:used_at).limit(25), TagWrapper, view_context)
  end

  def foreach_recent_badge
    CollectionWrapper.new(current_group.badges.desc(:created_at).limit(25), BadgeWrapper, view_context)
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

  def logo_img
    view_context.image_tag view_context.logo_path(current_group)
  end

  def logo_link
    link_to(logo_img, view_context.root_path)
  end

  def search_form
    %@<form accept-charset="UTF-8" action="#{view_context.search_index_path}" id="search" method="get">
      <div class='field'><input id="q" name="q" value="#{params[:q]}" type="text" class="textbox" /></div></form>@.html_safe
  end

  def signin_dropdown
    view_context.multiauth_dropdown("Sign In")
  end

  def signin_url
    view_context.link_to "Sign In", view_context.new_session_path(:user)
  end

  def unanswered_questions_url
    view_context.questions_url(:unanswered => 1)
  end

  def new_question_url
    view_context.new_question_url
  end

  def badges_url
    view_context.badges_url
  end

  def users_url
    view_context.users_url
  end

  def tags_url
    view_context.tags_url
  end

  def questions_url
    view_context.questions_url
  end

  def questions_feed_url
    view_context.questions_url(:format => "atom")
  end

  def hot_questions_url
    view_context.questions_url(:tab => "hot")
  end

  def featured_questions_url
    view_context.questions_url(:tab => "featured")
  end

  def current_group
    view_context.current_group
  end

  def current_theme
    @current_theme ||= current_group.current_theme
  end
end
