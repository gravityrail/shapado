require 'sham'
require 'ffaker'

Sham.email { Faker::Internet.email }
Sham.name  { Faker::Name.name }
Sham.login  { Faker::Name.name }
Sham.position(:unique => false)  { {"lat" => 0, "long" => 0} }
Sham.title { Faker::Lorem.sentence }
Sham.body { Faker::Lorem.paragraph }
Sham.domain { Faker::Company.name }

User.blueprint do
  login {Sham.login}
  email {Sham.email}
  password "test123"
  password_confirmation "test123"
  position {Sham.position}
  avatar {StringIO.new("MOCK")}
end

Group.blueprint do
  name {Sham.domain}
  subdomain {"#{name.gsub(" ", "-").gsub("_", "-")[0..30]}#{rand(100)}"}
  legend {"#{name} lengend"}
  description {"#{name} description" }
  default_tags {["testing"]}
  state "active"
  languages ["en", "es", "fr"]
  owner { User.make { |u| u.notification_opts = NotificationConfig.new} }
  activity_rate 0.0
end

Question.blueprint do
  title { Sham.title}
  position {Sham.position}
  votes {{}}
  comments {[]}
  group {Group.make { |g| g.notification_opts = NotificationConfig.make_unsaved}}
  user {User.make { |u| u.notification_opts = NotificationConfig.make_unsaved}}
end

Answer.blueprint do
  body { Sham.body }
  position {Sham.position}
  votes {{}}
  comments {[]}
  group {Group.make { |g| g.notification_opts = NotificationConfig.make_unsaved}}
  user {User.make { |u| u.notification_opts = NotificationConfig.make_unsaved}}
  question {Question.make}
end

Comment.blueprint do
  body { Sham.body }
  votes {{}}
  user {User.make { |u| u.notification_opts = NotificationConfig.make_unsaved}}
end

UserStat.blueprint do
  answer_tags { (0..rand(10)).to_a.map {|i| "tag#{i}"} }
  question_tags { (0..rand(10)).to_a.map {|i| "tag#{i}"} }
  expert_tags { (0..rand(10)).to_a.map {|i| "tag#{i}"} }
  tag_votes { (0..rand(10)).to_a.map {|i| "tag#{i}"} }
  user {User.make { |u| u.notification_opts = NotificationConfig.make_unsaved}}
end

NotificationConfig.blueprint do
  give_advice { true }
  activities { true }
  reports { true }
  new_answer { true }
  questions_to_twitter { true }
  badges_to_twitter { true }
  favorites_to_twitter { true }
  answers_to_twitter { true }
  comments_to_twitter { true }
end

CloseRequest.blueprint do
  reason { CloseRequest::REASONS[rand()*CloseRequest::REASONS.size]}
end

Search.blueprint do
  name { Sham.name }
  query {Faker::Lorem.sentence}
  group {Group.make}
  user {User.make}
end

Theme.blueprint do
  name { Sham.name }
  group {Group.make}
end

