class FollowUp
  include Mongoid::Document

  identity :type => String

  referenced_in :original_question, :class_name => "Question"
  referenced_in :original_answer, :class_name => "Answer"

  embedded_in :question, :inverse_of => :follow_up

  validates_presence_of :original_question
end
