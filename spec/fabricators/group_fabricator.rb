Fabricator(:group) do
  name {Faker::Company.name}
  subdomain {"#{name.gsub(" ", "-").gsub("_", "-")[0..30]}#{rand(100)}"}
  legend {"#{name} lengend"}
  description {"#{name} description" }
  default_tags {["testing"]}
  state "active"
  languages ["en", "es", "fr"]
  owner(:fabricator => :user)
  notification_opts { Fabricator.build(:notification_config ) }
  activity_rate 0.0
end
