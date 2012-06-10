namespace "shapado40to41" do
  task :levels => [:init] do
    Membership.all.each do |ms|
      print "."
      ms.level = LevelSystem.instance.level_for(ms.reputation)
      ms.save(:validate => false)
    end
  end

  task :activities => [:init] do
    sid = ShapadoVersion.where(:token => 'free').first.id
    Group.override({}, {:shapado_version_id => sid})
  end
  task :activities => [:init] do
    puts "Updating #{Activity.count} activities"

    Activity.all.each do |activity|
      next if activity.trackable_type == "Page" || activity.action == "destroy"

      question = activity.target

      if question.nil?
        question = activity.trackable rescue nil
      end

      if question.nil?
        print "I"
        next
      end

      if !question.kind_of?(Question)
        question = question.try(:question)
      end

      if !question.kind_of?(Question)
        puts "cannot handle activity: #{activity.id}"
        next
      end

      follower_ids = question.follower_ids+question.contributor_ids+[activity.user_id]
      activity.add_followers(*follower_ids)

      print "."
    end
  end

  task :stats => [:init] do
    Group.all.each do |g|
      if g.stats.blank?
        g.stats = GroupStat.new
        g.save
        print "."
      end
    end
  end
end
