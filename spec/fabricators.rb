Fabricator(:user) do
  login { Fabricate.sequence(:user) { |i| "user#{i}" } }
  email { Fabricate.sequence(:email) { |i| "user#{i}@example.com" } }
  password "test123"
  password_confirmation "test123"
  position {{:lat => 0, :long => 0}}
  avatar {StringIO.new("MOCK")}
end

Fabricator(:group) do
  name { Fabricate.sequence(:name) { |i| "group#{i}" } }
  subdomain {|g|g.name}
  legend { Fabricate.sequence(:legend) { |i| "the test group #{i}" }}
  description {|g|"#{g.name} description" }
  default_tags {["testing"]}
  state "active"
  languages ["en", "es", "fr"]
  owner { Fabricate(:user, :avatar => StringIO.new("MOCK")) }
  activity_rate 0.0
end

Fabricator(:question) do
  title { Fabricate.sequence(:title) { |i| "this is a generate question number #{i}?" } }
  position {{:lat => 0, :long => 0}}
  votes {{}}
  comments {[]}
  group!
  user!
end

Fabricator(:answer) do
  body { Fabricate.sequence(:body) { |i| "this is the answer number #{i}" } }
  position {{:lat => 0, :long => 0}}
  votes {{}}
  comments {[]}
  group!
  user!
  question!
end

Fabricator(:user_stat) do
  answer_tags { (0..rand(10)).to_a.map {|i| "tag#{i}"} }
  question_tags { (0..rand(10)).to_a.map {|i| "tag#{i}"} }
  expert_tags { (0..rand(10)).to_a.map {|i| "tag#{i}"} }
  tag_votes { (0..rand(10)).to_a.map {|i| "tag#{i}"} }
  user!
end

Fabricator(:close_request) do
  reason { CloseRequest::REASONS[rand()*CloseRequest::REASONS.size]}
end
