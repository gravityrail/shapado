
desc "Fix all"
task :fixall => [:environment, "fixdb:openid", "fixdb:groups", "fixdb:relocate", "fixdb:counters",
                 "fixdb:sync_counts", "fixdb:votes", "fixdb:questions", "fixdb:comments"] do
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

  task :sync_counts => [:environment] do
    votes = MongoMapper.database.collection("votes")
    comments = MongoMapper.database.collection("comments")
    puts "updating comment's counts"
    comments.find.each do |c|
      print "."
      votes_average=0
      votes.find(:voteable_id =>  c["_id"]).each do |v|
        votes_average+=v["value"]
      end
      comments.update({:_id => c["id"]},
                      {"$set" => {"votes_count" => votes.find(:voteable_id =>  c["_id"]).count,
                                  "votes_average" => votes_average}})

      if c["flags"]
        comments.update({:_id => c["id"]}, {"$set" => {"flags_count" => c["flags"].size}})
      end
    end

    puts "updating questions's counts"
    Question.find_each do |q|
      print "."
      votes_average=0
      q.votes.each {|e| votes_average+=e.value }
      q.set("flags_count" => q.flags.size, "votes_count" => q.votes.size, "votes_average" => votes_average)
    end
  end

  task :counters => :environment do
    Question.find_each do |q|
      q.set(:close_requests_count => q.close_requests.size)
      q.set(:open_requests_count => q.open_requests.size)
    end
  end

  task :questions => [:environment] do
    puts "updating questions#last_target_type"
    Question.find_each(:last_target_type.ne => nil) do |q|
      print "."
      if(q.last_target_type != "Comment")
        last_target = q.last_target_type.constantize.find(q.last_target_id)
      else
        data = MongoMapper.database.collection("comments").find_one(:_id => q.last_target_id)
        last_target = Comment.new(data)
#         p last_target.id
#         p MongoMapper.database.collection("comments").find_one(:_id => q.last_target_id)
      end

      if(last_target)
        if(last_target.respond_to?(:updated_at) && last_target.updated_at && last_target.updated_at.is_a?(String))
          last_target.updated_at = Time.parse(last_target.updated_at)
        end
        Question.update_last_target(q.id, last_target)
      end
    end
  end

  task :votes => [:environment] do
    puts "updating votes"
    Group.find_each do |group|
      count = 0

      comments = MongoMapper.database.collection("comments")
      questions = MongoMapper.database.collection("questions")
      MongoMapper.database.collection("votes").find({:group_id => group["_id"]}).each do |vote|
        vote.delete("group_id")
        id = vote.delete("voteable_id")
        klass = vote.delete("voteable_type")
        collection = comments
        if klass == "Question"
          collection = questions;
        end
        count += 1
        collection.update({:_id => id}, "$addToSet" => {:votes => vote})
      end
      if count > 0
        puts "Updated #{count} #{group["name"]} votes"
      end
    end
    MongoMapper.database.collection("votes").drop
  end

  task :comments => [:environment] do
    puts "updating comments"
    comments = MongoMapper.database.collection("comments")
    questions = MongoMapper.database.collection("questions")

    MongoMapper.database.collection("comments").find(:_type => "Comment").each do |comment|
        id = comment.delete("commentable_id")
        klass = comment.delete("commentable_type")
        collection = comments

        if klass == "Question"
          collection = questions;
        end

        collection.update({:_id => id}, "$addToSet" => {:comments => comment})
    end
    begin
      MongoMapper.database.collection("answers").drop
    ensure
      begin
        comments.rename("answers")
      rescue
        puts "comments collection doesn't exists"
      end
    end
    puts "updated comments"
  end

  task :groups => [:environment] do
    Group.find_each(:language => [nil, '', 'none']) do |group|
      lang = group.description.to_s.language
      puts "Updating #{group.name} subdomain='#{group.subdomain}' detected as: #{lang}"

      group.language = (lang == :spanish) ? 'es' : 'en'
      group.languages = DEFAULT_USER_LANGUAGES
      if group.valid?
        group.save
      else
        puts "Invalid group: #{group.errors.full_messages}"
      end
    end
  end

  task :relocate => [:environment] do
    doc = JSON.parse(File.read('data/countries.json'))
    i=0
    doc.keys.each do |key|
      User.all({ :country_name => key}).each do |u|
        p "#{u.login}: before: #{u.country_name}, after: #{doc[key]["address"]["country"]}"
        lat = doc[key]["lat"]
        lon = doc[key]["lon"]
        User.set({:_id => u.id},
                    {:position => GeoPosition.new(lat, lon).to_mongo,
                      :address => doc[key]["address"]})
#         FIXME
#         Comment.set({:user_id => u.id},
#                     {:position => GeoPosition.new(lat, lon),
#                       :address => doc[key]["address"]})
        Question.set({:user_id => u.id},
                    {:position => GeoPosition.new(lat, lon).to_mongo,
                      :address => doc[key]["address"]})
        Answer.set({:user_id => u.id},
                    {:position => GeoPosition.new(lat, lon).to_mongo,
                      :address => doc[key]["address"]})
      end
    end
  end

end
