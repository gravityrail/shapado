class Theme
  include Mongoid::Document
  include MongoidExt::Storage
  include Mongoid::Timestamps

  identity :type => String
  field :name, :type => String
  field :description, :type => String, :default => ""

  field :bg_color, :type => String, :default => "f2f2f2"
  field :fg_color, :type => String, :default => "404040"

  field :view_bg_color, :type => String, :default => "ffffff"
  field :view_fg_color, :type => String, :default => "404040"

  field :use_button_bg_color, :type => Boolean, :default => false
  field :button_bg_color, :type => String, :default => "ee681f"
  field :button_fg_color, :type => String, :default => "ffffff"

  field :use_link_bg_color, :type => Boolean, :default => false
  field :link_bg_color, :type => String, :default => "000000"
  field :link_fg_color, :type => String, :default => "EE681F"

  field :custom_css, :type => String, :default => ""
  field :community, :type => Boolean, :default => false
  field :ready, :type => Boolean, :default => false

  field :has_js, :type => Boolean, :default => false

  file_key :javascript, :max_length => 256.kilobytes
  file_key :stylesheet, :max_length => 256.kilobytes
  file_key :bg_image, :max_length => 256.kilobytes

  belongs_to :group
  before_create :js_mime

  validates_uniqueness_of :name, :allow_blank => false
  validates_presence_of :name

  def self.find_file_from_params(params, request)
    if request.path =~ /\/(css|bg_image|javascript)\/([^\/\.?]+)\/([^\/\.?]+)/
      @group = Group.find($2)
      @theme = Theme.find($3)
      if !@theme.community && @theme.group != @group
        @theme = @group.current_theme
      end

      case $1
      when "css"
        @theme.stylesheet
      when "bg_image"
        @theme.bg_image
      when "javascript"
        @theme.javascript
      end
    end
  end

  def self.create_default
    theme = Theme.create(:name => "Default", :community => true, :is_default => true)
    Jobs::Themes.async.generate_stylesheet(theme.id).commit!
    theme
  end

  def set_has_js(param)
    unless param.blank?
      self["has_js"] = true
    end
  end

  protected
  def js_mime
    self.javascript["extention"] = "js"
    self.javascript["content_type"] = "text/javascript"
  end
end
