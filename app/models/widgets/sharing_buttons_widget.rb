class SharingButtonsWidget < Widget
  field :settings, :type => Hash , :default => { :identica => true,
    :twitter => true, :linkedin => true, :thinkit => false,
    :facebook => true, :shapado => true,:custom_html => '',
    :on_show_question => true
  }

  protected
end
