class Report
  attr_reader :group, :since
  attr_reader :questions, :answers, :users, :badges, :votes

  def initialize(group, since = Time.now.yesterday)
    @group = group
    @since = since

    @questions = group.questions.where(:created_at => {:$gt => since}).count
    @answers = group.answers.where(:created_at => {:$gt => since}).count

    @users = User.count("membership_list.#{group.id}.reputation" => {:$exists => true})
    @badges = group.badges.where(:created_at => {:$gt => since}).count
  end
end
