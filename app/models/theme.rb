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

  field :custom_css, :type => String

  field :community, :type => Boolean, :default => false

  file_key :stylesheet, :max_length => 256.kilobytes
  file_key :bg_image, :max_length => 256.kilobytes

  belongs_to :group

  before_save :generate_stylesheet

  protected
  def generate_stylesheet
    css = StringIO.new
    css << "#container { color: ##{self.fg_color}; }"
    css << " body #container { background-color: ##{self.bg_color}; }"
    css << " body #container a { color: ##{self.link_fg_color}; }"

    css << " body #container .left-panel"
    css << ", body #container .content-panel .quick_question"
    css << ", body #container .content-panel #main-content-wrap"
    css << ", body #container .widget .module"
    css << ", body #container .widget footer"
    css << " { background-color: ##{self.view_bg_color}; }"
    css << " body #container .left-panel { color: ##{self.view_fg_color}; }"

    if self.use_link_bg_color
      css << " body #container a { background-color: ##{self.link_fg_color}; }"
    end

    css << " body #container from button { color: ##{self.button_fg_color}; }"
    if self.use_button_bg_color
      css << " body #container from button, body #container form .buttons input.save { background-color: ##{self.button_bg_color}; }"
    end

    self.stylesheet = css
  end
end
