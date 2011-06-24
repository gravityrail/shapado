class Theme
  include Mongoid::Document
  include MongoidExt::Storage
  include Mongoid::Timestamps

  identity :type => String
  field :name, :type => String

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

  file_key :stylesheet, :max_length => 256.kilobytes
  file_key :bg_image, :max_length => 256.kilobytes

  belongs_to :group

  validates_uniqueness_of :name, :allow_blank => false
end
