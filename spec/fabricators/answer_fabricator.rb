Fabricator(:answer) do
  body { Faker::Lorem.paragraph }
  position {{"lat" => 0, "long" => 0}}
  votes
  comments
  group
  user
  question
end
