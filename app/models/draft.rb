class Draft
  include Mongoid::Document
  include Mongoid::Timestamps

  identity :type => String
  field :question, :type => Question
  field :answer, :type => Answer

  def self.cleanup!
    Draft.delete_all(:created_at.lt => 8.days.ago)
  end
end
