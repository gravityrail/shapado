class Draft
  include Mongoid::Document
  timestamps!
  identity :type => String
  key :question, Question
  key :answer, Answer
end
