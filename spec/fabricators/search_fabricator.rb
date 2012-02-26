Fabricator(:search) do
  name { Faker::Name.name }
  query {Faker::Lorem.sentence}
  group {Group.make}
  user {User.make}
end
