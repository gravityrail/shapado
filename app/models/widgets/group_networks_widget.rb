class GroupNetworksWidget < Widget
  include Shapado::Models::Networks

  field :settings, :type => Hash, :default => { :on_mainlist => true  }
  field :networks, :type => Hash, :default => {}

  def update_settings(params)
    super(params)
    self[:networks] = find_networks(params[:networks])
  end
end
