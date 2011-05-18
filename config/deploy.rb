set :application, "shapado"
set :asset_packager, "jammit"

task :staging do |t|
  set :repository, "git://github.com/ricodigo/shapado.git"
  set :branch, "origin/next"
  set :rails_env, :production
  set :unicorn_workers, 1
  role :web, "metali.co"
  role :app, "metali.co"
  role :db,  "metali.co", :primary => true
end

namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "echo '#{`git describe`}' > #{current_path}/public/version.txt"

    assets.compass
    assets.package

    magent.restart
    bluepill.restart
  end
end

require 'ricodigo_capistrano_recipes'
