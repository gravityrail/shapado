class TagCloudWidget < Widget
  before_save :set_name

  field :settings, :type => Hash, :default => { :limit => 30 }

  validates_true_for :settings, :logic => lambda { |w| w.settings[:limit].to_i <= 30},
                     :message => lambda { |w| I18n.t("questions.model.messages.too_many_tags") if w.settings[:limit].to_i > 30 }



  protected
  def set_name
    self[:name] ||= "tag_cloud"
  end
end
