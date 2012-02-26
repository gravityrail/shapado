Fabricator(:theme) do
  name { Faker::Name.name }
  group {Group.make}
end
