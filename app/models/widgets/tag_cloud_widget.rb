class TagCloudWidget < Widget
  before_validation_on_create :set_name
  before_validation_on_update :set_name

  key :settings, Hash, :default => { :limit => 30, :on_welcome => true }

  validates_true_for :settings, :logic => lambda { |w| w.settings[:limit].to_i <= 30},
                     :message => lambda { |w| I18n.t("questions.model.messages.too_many_tags") if w.settings[:limit].to_i > 30 }



  protected
  def set_name
    self[:name] ||= "tag_cloud"
  end
end
