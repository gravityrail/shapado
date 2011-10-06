# Edit this Gemfile to bundle your application's dependencies.
# This preamble is the current preamble for Rails 3 apps; edit as needed.
source 'http://rubygems.org'

gem 'rails', '3.1.0'

if RUBY_PLATFORM !~ /mswin|mingw/
  gem 'rdiscount', :git => 'git://github.com/ricodigo/rdiscount.git'

  gem "ruby-stemmer", "~> 0.8.2", :require => "lingua/stemmer"
  gem "sanitize", "2.0.3"

  gem 'magic'
  gem 'mini_magick', '~> 2.3'
  gem 'nokogiri'
  gem 'mechanize'
else
  gem "maruku", "0.6.0"
end

# ui
gem "haml"
gem "sass"
gem 'compass', '0.11.1'
gem "compass-colors", "0.9.0"
gem "fancy-buttons", "1.1.1"
gem 'kaminari'

# mongodb
gem 'bson', '1.4.0'
gem 'bson_ext', '1.4.0'

gem 'mongo', '1.4.0'
gem 'mongoid', :git => 'git://github.com/mongoid/mongoid.git', :branch => "2.3.0-stable"
gem 'mongoid_ext', :git => "git://github.com/dcu/mongoid_ext.git"

gem 'mongo_store', :git => 'https://github.com/Houdini/mongo_store.git'

# utils

gem 'jammit'
gem "whatlanguage", "1.0.0"
gem "uuidtools", "~> 2.1.1"
gem "magent", "0.6.2"
gem "bug_hunter", :git => "git://github.com/ricodigo/bug_hunter.git"

gem 'goalie', '~> 0.0.4'
gem 'dynamic_form'
gem 'rinku', '~> 1.2.2', :require => 'rails_rinku'

gem "rack-recaptcha", "0.2.2", :require => "rack/recaptcha"

gem "twitter-text", "1.1.8"
gem "twitter_oauth"
gem 'social_widgets', :git => 'https://git.gitorious.org/social_widgets/social_widgets.git'
gem 'activemerchant', '1.16.0'
gem 'pdfkit', :git => 'git://github.com/jdpace/PDFKit.git' # apt-get install wkhtmltopdf

gem 'geoip'

# authentication
gem 'omniauth', '~> 0.3.0'
gem 'oa-openid', '~> 0.3.0', :require => 'omniauth/openid'
gem "oa-oauth", '~> 0.3.0', :require => "omniauth/oauth"

gem 'multiauth', :git => "http://github.com/dcu/multiauth.git"

gem 'orm_adapter'
gem 'devise', "~> 1.4.0"

gem 'whenever', :require => false
gem 'rack-ssl', :require => false

gem 'state_machine', "0.10.4"

gem "xapian-ruby", '1.2.7'
gem "xapit", :git => "git://github.com/dcu/xapit.git"

group :deploy do
  gem 'capistrano', :require => false
  gem 'ricodigo-capistrano-recipes', "~> 0.1.3", :require => false
  gem 'unicorn', '4.1.1', :require => false
end

group :scripts do
  gem 'eventmachine', '~> 0.12.10'
  gem 'em-websocket', '~> 0.3.0'
  gem 'twitter', '1.7.2'
end

group :test do
  gem 'capybara', '1.0.0'
  gem "capybara-webkit", '1.0.0.beta4'
  gem 'launchy'
  gem 'machinist_mongo', :require => 'machinist/mongoid'
  gem 'ffaker'
  gem 'simplecov'
  gem "autotest"
  gem 'ruby-debug19', '0.11.6', :require => 'ruby-debug'
end

group :development do
  gem "database_cleaner"
  gem "rspec", ">= 2.0.1"
  gem "rspec-rails", ">= 2.0.1"
  gem "remarkable_mongoid", ">= 0.5.0"
  gem 'hpricot'
  gem 'ruby_parser'
  gem 'mongrel', '1.2.0.pre2'
  gem 'niftier-generators', '0.1.2'
  gem 'ruby-prof'
  gem 'tunnlr_connector', :git => "git://github.com/dcu/tunnlr_connector.git", :branch => "patch-1", :require => "tunnlr"
  gem 'rails-dev-boost', :git => 'git://github.com/thedarkone/rails-dev-boost.git', :require => 'rails_development_boost'
end
