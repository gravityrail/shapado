class SharingButtonsWidget < Widget
  before_validation_on_create :set_name
  before_validation_on_update :set_name

  key :settings, Hash , :default => { :identica => true,
    :twitter => true, :linkedin => true, :thinkit => false,
    :facebook => true, :shapado => true,:custom_html => '',
    :on_show_question => true
  }

  protected
  def set_name
    self[:name] ||= "sharing_buttons"
  end
end
