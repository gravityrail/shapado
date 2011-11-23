class UserWrapper < ModelWrapper
  def url
    view_context.user_url(@target)
  end

  def avatar
    view_context.avatar_img(@target, :size => 'small')
  end

  def avatar_url
    view_context.avatar_url(@target, :size => 'small')
  end

  def name
    @target.display_name
  end

  def reputation
    view_context.format_number(current_config.reputation.to_i)
  end

  def gold_badges_count
    current_config.gold_badges_count
  end

  def silver_badges_count
    current_config.silver_badges_count
  end

  def bronze_badges_count
    current_config.bronze_badges_count
  end

  def follow_button
    view_context.follow_suggestion_link(@target)
  end

  def respond_to?(method, priv = false)
    super(method, priv) || method =~ /avatar_url_(\d+)/
  end

  protected
  def current_config
    @current_config ||= @target.config_for(current_group)
  end

  def method_missing(name, *args, &block)
    if name =~ /(avatar_url)_(\d+)/
      avatar_url.sub("size=32", "size=#{$2}")
    else
      @target.send(name, *args, &block)
    end
  end
end
