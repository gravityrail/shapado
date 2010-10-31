module Jobs
  class Activities
    extend Jobs::Base

    def self.on_activity(group_id, user_id)
      user = User.first(:_id => user_id, :select => [:_id])
      group = Group.first(:_id => group_id, :select => [:_id])

      days = user.config_for(group).activity_days
      if days > 100
        create_badge(user, group, :token => "fanatic", :unique => true)
      elsif days > 20
        create_badge(user, group, :token => "addict", :unique => true)
      elsif days > 8
        create_badge(user, group, :token => "shapado", :unique => true)
      end
    end

    def self.on_update_answer(answer_id)
      answer = Answer.find(answer_id)
      user = answer.updated_by

      create_badge(user, answer.group, :token => "editor", :unique => true)
    end

    def self.on_destroy_answer(answer_id, attributes)
      deleter = User.find!(answer_id)
      group = Group.find(attributes["group_id"])

      if deleter.id == attributes["user_id"]
        if attributes["votes_average"] >= 3
          create_badge(deleter, group, :token => "disciplined", :unique => true)
        end

        if attributes["votes_average"] <= -3
          create_badge(deleter, group, :token => "peer_pressure", :unique => true)
        end
      end
    end

    def self.on_comment(comment_i)
      comment = Comment.find!(comment_id)
      commentable = comment.commentable
      group = comment.group
      user = comment.user

      if user.comments.count(:group_id => comment.group_id, :_type => {:$ne => "Answer"}) >= 10
        create_badge(user, group, :token => "commentator", :source => comment, :unique => true)
      end
    end

    def self.on_follow(follower_id, followed_id, group_id)
      follower = User.find(follower_id)
      followed = User.find(followed_id)
      group = Group.find(group_id)

      if follower.following_count > 1
        create_badge(follower, group, :token => "friendly",:source => followed, :unique => true)
      end

      if followed.followers_count >= 100
        create_badge(followed, group, :token => "celebrity",:unique => true)
      elsif followed.followers_count >= 50
        create_badge(followed, group, :token => "popular_person",:unique => true)
      elsif followed.followers_count >= 10
        create_badge(followed, group, :token => "interesting_person",:unique => true)
      end
    end

    def self.on_unfollow(follower_id, followed_id, group_id)
    end

    def self.on_flag(user_id, group_id)
      create_badge(User.find(user_id), Group.find(group_id), :token => "citizen_patrol", :unique => true)
    end

    def self.on_rollback(question_id)
      question = Question.find(question_id)
      create_badge(question.updated_by, question.group, :token => "cleanup", :source => question, :unique => true)
    end
  end
end