
module Jobs
  class Answers
    extend Jobs::Base

    def self.on_favorite_answer(answer_id, favoriter_id, link)
      answer = Answer.find(answer_id)
      user = answer.user
      question = answer.question
      group = question.group
      favoriter = User.find(favoriter_id)
      if answer.favorites_count >= 25
        create_badge(user, group, {:token => "favorite_answer", :source => answer}, {:unique => true, :source_id => answer.id})
      end

      if answer.favorites_count >= 100
        create_badge(user, group, {:token => "stellar_answer", :source => answer}, {:unique => true, :source_id => answer.id})
      end

      if favoriter.notification_opts.favorites_to_twitter
        link = shorten_url(link, answer)
        author = answer.user
        title = question.title
        message = I18n.t('jobs.answers.on_favorite_answer.send_twitter', :question => title, :author => author.login, :locale => user.language)
        status = make_status(message, link, 138)
        favoriter.twitter_client.update(status)
      end
    end

    def self.on_create_answer(question_id, answer_id)
      question = Question.find(question_id)
      group = question.group
      answer = question.answers.find(answer_id)
      Question.update_last_target(question.id, answer)

      question.answer_added!
      group.on_activity(:answer_question)

      unless answer.anonymous
        answer.user.stats.add_answer_tags(*question.tags)
        answer.user.on_activity(:answer_question, group)

        search_opts = {:"notification_opts.#{group.id}.new_answer" => {:$in => ["1", true]},
                        :_id => {:$ne => answer.user.id}}

        users = question.followers.only(:email, :name).where(search_opts).all.to_a # TODO: optimize!!
        users.push(question.user) if !question.user.nil? && question.user != answer.user
        followers = answer.user.followers.where(:languages => [question.language], :group_id => group.id).only(:email, :name).to_a

        users ||= []
        followers ||= []
        (users - followers).each do |u|
          if !u.email.blank? && u.notification_opts.new_answer
            Notifier.new_answer(u, group, answer, false).deliver
          end
        end

        followers.each do |u|
          if !u.email.blank? && u.notification_opts.new_answer
            Notifier.new_answer(u, group, answer, true).deliver
          end
        end
      end
    end
  end
end
