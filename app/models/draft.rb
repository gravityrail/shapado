class Draft
  include Mongoid::Document
  include Mongoid::Timestamps

  identity :type => String
  field :question, :type => Question
  field :answer, :type => Answer
end
