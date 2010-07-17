
file = File.join(Rails.root, "data", "GeoLiteCity.dat")

if File.exist?(file)
  Localize = GeoIP.new(file)
else
  puts "Missing GeoIP data. Please run '#{Rails.root}/script/update_geoip'"
end


