namespace "shapado40to41" do
  task :levels => [:init] do
    Membership.all.each do |ms|
      print "."
      ms.level = LevelSystem.instance.level_for(ms.reputation)
      ms.save(:validate => false)
    end
  end
end
