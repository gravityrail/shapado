class Draft
  include Mongoid::Document
  timestamps!
  key :_id, String
  key :question, Question
  key :answer, Answer
end
