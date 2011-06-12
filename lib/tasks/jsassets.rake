

  desc "generating js dev assets"
  task :jsassets do
    assets = YAML::load( File.open( 'config/assets.yml' ) )

    assets["javascripts"].keys.each do |k|
      assets["javascripts"][k].map! do |file|
        file.gsub('public','')
      end
    end
    assets["stylesheets"].keys.each do |k|
      assets["stylesheets"][k].map! do |file|
        file.gsub('public','')
      end
    end
    jsassets = assets["javascripts"].to_json
    cssassets = assets["stylesheets"].to_json

    assets_content = "/*THIS FILE IS AUTO-GENERATED FOR DEV, DO NOT MODIFY IT. MODIFY config/assets.yml INSTEAD*/\n jsassets = #{jsassets}; cssassets = #{cssassets};"

    File.open('public/javascripts/app/initializers/assets_dev.js', 'w') do |f|
      f.puts assets_content
    end
    puts "done."
  end
