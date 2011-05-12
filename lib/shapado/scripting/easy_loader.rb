Dir.chdir(File.dirname(__FILE__)) do
  require 'bundler/setup'
  Bundler.setup
end

require 'rails'

module Rails
  def self.root
    Bundler.root
  end

  def self.env
    ENV['RAILS_ENV'] || "development"
  end
end
Rails.logger = Logger.new("#{Rails.root}/log/#{File.basename($0).parameterize.to_s}.log")

require 'mongoid'
require 'mongoid_ext'
require 'devise'
require 'action_mailer'
require 'action_controller'
require 'action_view'
require 'state_machine'
require 'magent'
require 'haml'
require 'haml/template'
require 'sass'

require './vendor/plugins/i18n_action_mailer/lib/i18n_action_mailer'

ActionController::Base.prepend_view_path "#{Rails.root}/app/views"

Dir.chdir(Rails.root.to_s) do
  Mongoid.load!("./config/mongoid.yml")
  Magent.setup(YAML.load_file(Rails.root.join('config', 'magent.yml')),
                  Rails.env, {})

  MongoidExt.init

  # initializers
  require './config/load_config'
  require './config/initializers/01_locales'
  require './config/initializers/constants'
  require './config/initializers/devise'

  ActiveSupport::Dependencies.mechanism = :require
  ActiveSupport::Dependencies.autoload_paths << ::File.expand_path("lib")
  $:.unshift ::File.expand_path("app/helpers")
  $:.unshift ::File.expand_path("lib")

  Dir.glob("app/models/**/*.rb") do |model_path|
    dirname = ::File.dirname(::File.expand_path(model_path))
    ActiveSupport::Dependencies.autoload_paths << dirname if !ActiveSupport::Dependencies.autoload_paths.include?(dirname)

    ::File.basename(model_path, ".rb").classify.constantize
  end
end
