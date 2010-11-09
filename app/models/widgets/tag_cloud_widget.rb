class TagCloudWidget < Widget
  validate :set_name, :on => :create
  field :settings, :type => Hash, :default => { :limit => 30, :on_welcome => true }

  validate :validate_settings



  protected
  def set_name
    self[:name] ||= "tag_cloud"
  end

  def validate_settings
    if w.settings[:limit].to_i > 30
      self.errors.add :settings, I18n.t("questions.model.messages.too_many_tags")
    end
  end
end
