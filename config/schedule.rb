APP_ROOT = File.expand_path("../../", __FILE__)

daily_report = "#{APP_ROOT}/script/daily_report production"
cleanup = "#{APP_ROOT}/script/cleanup production"
twitter = "#{APP_ROOT}/script/import_twitter production"
email = "#{APP_ROOT}/script/import_email production"

env "PATH", ENV["PATH"]
set :output, "#{APP_ROOT}/log/crontab.log"

every :saturday, :at => "2:50 am" do
  command daily_report
end

every :wednesday, :at => "2:50 am" do
  command cleanup
end

every 5.minutes do
  command twitter
end

every 8.minutes do
  command email
end
