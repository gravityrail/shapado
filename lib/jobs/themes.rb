module Jobs
  class Themes
    extend Jobs::Base

    def self.generate_stylesheet(theme_id)
      theme = Theme.find(theme_id)
      css = StringIO.new
      template_file = File.join(Rails.root,"lib","sass","theme_template.scss")
      template = Sass::Engine.new(self.define_vars(theme) << File.read(template_file) << "\n" << theme.custom_css || "",
                        {:style => Sass::Plugin.options[:style], :syntax => :scss, :cache => false, :load_paths => []})
      if Rails.env == "production"
        css << YUI::CssCompressor.new.compress(template.render)
      else
        css << template.render
      end
      theme.stylesheet = css
      theme.stylesheet["extension"] = "css"
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
$brand_color: ##{theme.brand_color};
$fluid: #{theme.fluid};
@
    end
  end
end
