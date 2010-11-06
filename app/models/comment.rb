class Comment
  include MongoMapper::EmbeddedDocument
  include Support::Voteable
#   include Shapado::Models::GeoCommon FIXME

#   timestamps! FIXME

  key :_id, String
  key :body, String, :required => true
  key :language, String, :default => "en"
  key :banned, Boolean, :default => false

  key :created_at, Time, :default => Time.now # FIXME
  key :updated_at, Time, :default => Time.now # FIXME
  key :position, GeoPosition, :default => GeoPosition.new(0, 0) # FIXME

  key :user_id, String
  belongs_to :user

  alias :commentable :_root_document

  validates_presence_of :user

  def group
    commentable.group
  end

  def commentable_type
    commentable.class.to_s
  end

  def can_be_deleted_by?(user)
    ok = (self.user_id == user.id && user.can_delete_own_comments_on?(self.group)) || user.mod_of?(self.group)
    if !ok && user.can_delete_comments_on_own_questions_on?(self.group) && (q = self.find_question)
      ok = (q.user_id == user.id)
    end

    ok
  end

  def find_question
    question = nil
    if self.commentable.kind_of?(Question)
      question = self.commentable
    elsif self.commentable.respond_to?(:question)
      question = self.commentable.question
    end

    question
  end

  def question_id
    question_id = nil

    if self.commentable.is_a?(Question)
      question_id = self.commentable.id
    elsif self.commentable.is_a?(Answer)
      question_id = self.commentable.question_id
    elsif self.commentable.respond_to?(:question)
      question_id = self.commentable.question_id
    end

    question_id
  end

  def find_recipient
    if self.commentable.respond_to?(:user)
      self.commentable.user
    end
  end
end
