
class CloseRequest
  include Mongoid::Document
  REASONS = %w{dupe ot no_question not_relevant spam}

  identity :type => String
  field :reason, :type => String
  field :comment, :type => String

  referenced_in :user
  embedded_in :closeable, :inverse_of => :close_requests

  validates_presence_of :user
  validates_inclusion_of :reason, :in => REASONS


  validate :should_be_unique
  validate :check_reputation

  def increment_counter
    self.closeable.increment(:close_requests_count => 1)
  end

  def decrement_counter
    self.closeable.decrement(:close_requests_count => 1)
  end

  protected
  def should_be_unique
    request = self.closeable.close_requests.detect{ |rq| rq.user_id == self.user_id }
    valid = (request.nil? || request.id == self.id)

    unless valid
      self.errors.add(:user, I18n.t("close_requests.model.messages.already_requested"))
    end

    valid
  end

  def check_reputation
    if self.closeable.can_be_requested_to_close_by?(self.user)
      return true
    end

    if ((self.closeable.user_id == self.user_id) && !self.user.can_vote_to_close_own_question_on?(self.closeable.group))
      reputation = self.closeable.group.reputation_constrains["vote_to_close_own_question"]
      self.errors.add(:reputation, I18n.t("users.messages.errors.reputation_needed",
                                          :min_reputation => reputation,
                                          :action => I18n.t("users.actions.vote_to_close_own_question")))
      return false
    end

    unless self.user.can_vote_to_close_any_question_on?(self.closeable.group)
      reputation = self.closeable.group.reputation_constrains["vote_to_close_any_question"]
            self.errors.add(:reputation, I18n.t("users.messages.errors.reputation_needed",
                                          :min_reputation => reputation,
                                          :action => I18n.t("users.actions.vote_to_close_any_question")))
      return false
    end

    true
  end
end
