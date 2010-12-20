# Edit this Gemfile to bundle your application's dependencies.
# This preamble is the current preamble for Rails 3 apps; edit as needed.
source 'http://rubygems.org'

gem 'rails', '3.0.3'

if RUBY_PLATFORM !~ /mswin|mingw/
  gem 'rdiscount', '1.6.5'

  gem "ruby-stemmer", "~> 0.8.2", :require => "lingua/stemmer"
  gem "sanitize", "1.2.1"

  gem 'magic'
  gem 'nokogiri'
  gem 'mechanize'
else
  gem "maruku", "0.6.0"
end

# ui
gem "haml"
gem 'compass', '0.10.6.pre.1'
gem "compass-colors", "0.3.1"
gem "fancy-buttons", "0.5.5"
gem 'will_paginate', :git => 'git://github.com/mislav/will_paginate.git', :branch => "rails3"
# mongodb
gem 'bson', '1.1.2'
gem 'bson_ext', '1.1.2'

gem 'mongo', '1.1.2'
gem 'mongoid', '2.0.0.beta.20'
gem 'mongoid_ext', :git => "git://github.com/dcu/mongoid_ext.git"

# utils

gem "whatlanguage", "1.0.0"
gem "uuidtools", "2.1.1"
gem "magent", "0.5.2"

gem 'goalie', '~> 0.0.4'
gem 'dynamic_form'

gem "differ", "0.1.1"
gem "rack-recaptcha", "0.2.2", :require => "rack/recaptcha"

gem "twitter-text", "1.1.8"
gem 'sanitize', '1.2.1'
gem "twitter_oauth"

# authentication
gem 'omniauth', '~> 0.1.6'
gem 'multiauth', :git => "http://github.com/dcu/multiauth.git"

gem 'orm_adapter'
gem 'devise', :git => 'http://github.com/plataformatec/devise.git'


group :scripts do
  gem 'eventmachine', '~> 0.12.10'
  gem 'em-websocket', '~> 0.1.4'
  gem 'cronedit'
end

group :test do
  gem "fabrication"
  gem "autotest"
end

group :development do
  gem "database_cleaner"
  gem "rspec", ">= 2.0.1"
  gem "fabrication"
  gem "rspec-rails", ">= 2.0.1"
  gem "remarkable_mongoid", ">= 0.5.0"
  gem 'hpricot'
  gem 'ruby_parser'
  gem 'mongrel', '1.2.0.pre2'
  gem 'niftier-generators', '0.1.2'
end

