class Theme
  include Mongoid::Document
  include MongoidExt::Storage
  include Mongoid::Timestamps

  identity :type => String
  field :name, :type => String

  field :bg_color, :type => String, :default => "000000"
  field :fg_color, :type => String, :default => "ffffff"

  field :view_bg_color, :type => String, :default => "ffffff"
  field :view_fg_color, :type => String, :default => "ffffff"

  field :use_button_bg_color, :type => Boolean, :default => false
  field :button_bg_color, :type => String, :default => "000000"
  field :button_fg_color, :type => String, :default => "ffffff"

  field :use_link_bg_color, :type => Boolean, :default => false
  field :link_bg_color, :type => String, :default => "000000"
  field :link_fg_color, :type => String, :default => "EE681F"

  field :custom_css, :type => String, :default => ""

  field :community, :type => Boolean, :default => false

  file_key :stylesheet, :max_length => 256.kilobytes
  file_key :bg_image, :max_length => 256.kilobytes

  belongs_to :group

  before_save :generate_stylesheet
  validates_uniqueness_of :name, :allow_blank => false

  protected
  def generate_stylesheet
    css = StringIO.new
    template_file = File.join(Rails.root,"lib","sass","theme_template.scss")
    css = Sass.compile(File.read(template_file), {:style => :compressed})
    css << self.custom_css || ""
    self.stylesheet = css
  end
end
