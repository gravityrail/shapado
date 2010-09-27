# Edit this Gemfile to bundle your application's dependencies.
# This preamble is the current preamble for Rails 3 apps; edit as needed.
source 'http://rubygems.org'

gem 'rails', '3.0.0'

if RUBY_PLATFORM !~ /mswin|mingw/
  gem 'rdiscount', '1.6.5'

  gem "ruby-stemmer", "~> 0.8.2", :require => "lingua/stemmer"
  gem "sanitize", "1.2.1"

  gem 'magic'
  gem 'nokogiri'
  gem 'mechanize'
  gem 'bson_ext', '1.0.9', :require => "bson"
else
  gem "maruku", "0.6.0"
end

gem "bson", "1.0.9", :require => "bson"
gem "mongo", "1.0.9"

gem "jnunemaker-validatable", "1.8.4", :require => "validatable"
gem "mongo_mapper", :git => 'http://github.com/jnunemaker/mongomapper.git'
gem "mongomapper_ext", "0.4.0"

gem "compass", "0.10.5", :require => "compass"
gem "compass-colors", "0.3.1"
gem "fancy-buttons", "0.5.5"

gem "geoip"
gem "whatlanguage", "1.0.0"
gem "uuidtools", "2.1.1"
gem "magent", "0.4.2"

gem 'goalie'
gem 'dynamic_form'
gem 'haml', '~> 3.0.13'

gem "differ", "0.1.1"
gem "rack-recaptcha", "0.2.2", :require => "rack/recaptcha"

gem "twitter-text", "1.1.8"
gem 'sanitize', '1.2.1'

# devise
gem 'oauth2', '0.0.13'
gem 'devise', :git => 'http://github.com/plataformatec/devise.git'
#gem 'devise-mongo_mapper', :git => 'http://github.com/collectiveidea/devise-mongo_mapper.git'
gem 'devise_openid_authenticatable', '1.0.0.alpha7', :git => "http://github.com/nbudin/devise_openid_authenticatable.git"
gem 'devise-twitter', '0.1.1'
gem 'multiauth', '0.1.3' #, :path => "vendor/gems/multiauth"


group :development do
  gem 'hpricot'
  gem 'ruby_parser'
  gem 'mongrel', '1.2.0.pre2'
  gem 'niftier-generators', '0.1.2'
end

