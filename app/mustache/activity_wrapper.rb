class ActivityWrapper < ModelWrapper
  def action
    @target.humanize_action
  end

  def user
    UserWrapper.new(@target.user, view_context)
  end

  def user_url
    view_context.user_url(@target.user)
  end

  def user_name
    @target.user.display_name
  end

  def target_url
    @target.url_for_trackable(current_group.domain)
  end

  def target_name
    @target.target_name
  end
end
