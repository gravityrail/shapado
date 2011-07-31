class ShareWidget < Widget
  field :settings, :type => Hash, :default => {}
  field :share_links, :type => Hash, :default => {'facebook_like' => 1, 'twitter_count' => 1, 'google_plus' => 1, 'linked_in_count' => 1, 'stumble_upon' => 1}

  SHARE_LINKS = AppConfig.share_links.keys
  def update_settings(params)
    super(params)
    #self[:share_links] = find_networks(params[:networks])
  end
end
