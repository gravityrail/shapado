desc "Fix all"
task :fixall => [:environment, "fixdb:openid"] do
end

namespace :fixdb do
  task :openid => [:environment] do
    User.find_each do |user|
      next if user.identity_url.blank?

      puts "Updating: #{user.login}"
      user.push_uniq(:auth_keys => "open_id_#{user[:identity_url]}")
      user.unset(:identity_url => 1)
    end
  end
end

