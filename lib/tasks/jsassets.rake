require 'digest/md5'


desc "generating js assets"
task :jsassets do
  puts "generating dev assets"

  assets = YAML::load( File.open( 'config/assets.yml' ) )

  assets["javascripts"].keys.each do |k|
    assets["javascripts"][k].map! do |file|
      digest = Digest::MD5.hexdigest(File.read(file))[0..9]
      file.gsub('public','')+'?'+digest
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
  puts "done generating assets_dev.js."
  puts "generating prod assets"

  assets = YAML::load( File.open( 'config/assets.yml' ) )
  assets["javascripts"].keys.each do |k|
    file = "public/packages/#{k}.js"
    digest = Digest::MD5.hexdigest(File.read(file))[0..9]
    assets["javascripts"][k] = ["/packages/#{k}.js?#{digest[0..9]}"]
  end
  assets["stylesheets"].keys.each do |k|
    file = "public/packages/#{k}.css"
    digest = Digest::MD5.hexdigest(File.read(file))[0..9]
    assets["stylesheets"][k] = ["/packages/#{k}.css"]
  end
  jsassets = assets["javascripts"].to_json
  cssassets = assets["stylesheets"].to_json
  assets_content = "/*THIS FILE IS AUTO-GENERATED FOR DEV, DO NOT MODIFY IT. MODIFY config/assets.yml INSTEAD*/\n jsassets = #{jsassets}; cssassets = #{cssassets};"
  File.open('public/javascripts/app/initializers/assets.js', 'w') do |f|
    f.puts assets_content
  end
  Jammit.package!
  puts "done generating assets.js."
end
