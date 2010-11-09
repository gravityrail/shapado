class SharingButtonsWidget < Widget
  validate :set_name, :on => :create

  field :settings, :type => Hash , :default => { :identica => true,
    :twitter => true, :linkedin => true, :thinkit => false,
    :facebook => true, :shapado => true,:custom_html => '',
    :on_show_question => true
  }

  protected
  def set_name
    self[:name] ||= "sharing_buttons"
  end
end
