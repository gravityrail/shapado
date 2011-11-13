class BadgeWrapper < ModelWrapper
  def badge_url
    view_context.badge_url(@target)
  end

  def user_url
    view_context.user_url(@target.user)
  end

  def user_name
    @target.user.name
  end
end