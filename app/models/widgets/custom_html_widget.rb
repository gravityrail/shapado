class CustomHtmlWidget < Widget
  field :settings, :type => Hash, :default => {'content' => "", 'title' =>"", 'fo0ter'=>"" }

  def content
#     settings['content'][I18n.locale.to_s.split("-").first] || ""
    settings['content']
  end

  def title
#     settings['title'][I18n.locale.to_s.split("-").first] || ""
    settings['title']
  end

  def footer
    settings['footer']
#     settings['footer'][I18n.locale.to_s.split("-").first] || ""
  end
end
