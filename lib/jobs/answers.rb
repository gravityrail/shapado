
module Jobs
  class Answers
    extend Jobs::Base

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

        search_opts = {"notification_opts.#{group.id}.new_answer" => {:$in => ["1", true]},
                        :_id => {:$ne => answer.user.id},
                        :select => ["email"]}

        users = question.followers.all(search_opts) # TODO: optimize!!
        users.push(question.user) if !question.user.nil? && question.user != answer.user
        followers = answer.user.followers(:languages => [question.language], :group_id => group.id)

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
