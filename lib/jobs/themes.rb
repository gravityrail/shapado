module Jobs
  class Themes
    extend Jobs::Base

    def self.generate_stylesheet(theme_id)
      theme = Theme.find(theme_id)
      css = StringIO.new
      template_file = File.join(Rails.root,"lib","sass","theme_template.scss")
      template = Sass::Engine.new(self.define_vars(theme) << File.read(template_file),
                        {:style => :compressed, :syntax => :scss, :cache => false, :load_paths => []})
      css << template.render
      css << theme.custom_css || ""
      theme.stylesheet = css
      theme.stylesheet["extention"] = "css"
      theme.stylesheet["content_type"] = "text/css"
      theme.ready = true
      theme.save
    end

    private
    def self.define_vars(theme)
%@
$has_bg_image: #{theme.has_bg_image?};
$bg_color: ##{theme.bg_color};
$fg_color: ##{theme.fg_color};
$bg_image_url: '/_files/themes/bg_image/#{theme.group_id}/#{theme.id}';
$view_bg_color: ##{theme.view_bg_color};
$view_fg_color: ##{theme.view_fg_color};

$button_bg_color: ##{theme.button_bg_color};
$button_fg_color: ##{theme.button_fg_color};

$use_link_bg_color: #{theme.use_link_bg_color};
$link_bg_color: ##{theme.link_bg_color};
$link_fg_color: ##{theme.link_fg_color};
@
    end
  end
end
