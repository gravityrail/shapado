class TagCloudWidget < Widget
  before_save :set_name

  field :settings, :type => Hash, :default => { :limit => 30 }

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
