class BadgeWrapper < ModelWrapper
  def badge_url
    view_context.badge_url(@target)
  end

  def user_url
    view_context.user_url(@target.user)
  end

  def user_name
    @target.user.display_name
  end

  def user
    UserWrapper.new(@target.user, view_context)
  end
end