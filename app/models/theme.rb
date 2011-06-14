class Theme
  include Mongoid::Document
  include MongoidExt::Storage
  include Mongoid::Timestamps

  identity :type => String
  field :name, :type => String

  field :bg_color, :type => String, :default => "000000"
  field :fg_color, :type => String, :default => "ffffff"
  field :button_bg_color, :type => String, :default => "000000"
  field :button_fg_color, :type => String, :default => "ffffff"

  field :link_bg_color, :type => String, :default => "000000"
  field :link_fg_color, :type => String, :default => "ffffff"

  field :custom_css, :type => String

  field :community, :type => Boolean, :default => false

  file_key :stylesheet, :max_length => 256.kilobytes
  file_key :bg_image, :max_length => 256.kilobytes

  belongs_to :group

  before_save :generate_stylesheet

  protected
  def generate_stylesheet
    css = StringIO.new
    css << "body .container { color: ##{self.fg_color} }"
    css << "body .container { background-color: ##{self.bg_color} }"

    self.stylesheet = css
  end
end
