class Answer
  include Mongoid::Document
  include Mongoid::Timestamps
  include MongoidExt::Filter
  include MongoidExt::Random

  include Support::Versionable
  include Support::Voteable
  include Shapado::Models::GeoCommon
  identity :type => String

  field :body, :type => String, :required => true
  field :language, :type =>  String, :default => "en"
  index :language
  field :flags_count, :type =>  Integer, :default => 0
  field :banned, :type =>  Boolean, :default => false
  index :banned
  field :wiki, :type => Boolean, :default => false
  field :anonymous, :type => Boolean, :default => false
  index :anonymous
  field :short_url, :type => String

  field :rewarded, :type => Boolean, :default => false

  field :favoriters_count, :type => Integer, :default => 0
  references_and_referenced_in_many :favoriters, :class_name => "User"

  referenced_in :group
  index :group_id

  referenced_in :user
  index :user_id

  referenced_in :updated_by, :class_name => "User"
  referenced_in :original_question, :class_name => "Question"

  referenced_in :question
  index :question_id

  embeds_many :flags
  embeds_many :comments#, :order => "created_at asc"

  validates_presence_of :user_id
  validates_presence_of :question_id

  versionable_keys :body
  filterable_keys :body

  validate :disallow_spam
  validate :check_unique_answer, :if => lambda { |a| (!a.group.forum && !a.disable_limits?) }

  before_destroy :unsolve_question

  def ban
    self.collection.update({:_id => self.id}, {:$set => {:banned => true}})
  end

  def self.minimal
    without(:_keywords, :flags, :votes, :versions)
  end

  def self.ban(ids)
    ids.each do |id|
      self.collection.update({:_id => id}, {:$set => {:banned => true}})
    end
  end

  def can_be_deleted_by?(user)
    ok = (self.user_id == user.id && user.can_delete_own_comments_on?(self.group)) || user.mod_of?(self.group)
    if !ok && user.can_delete_comments_on_own_questions_on?(self.group) && (q = self.question)
      ok = (q.user_id == user.id)
    end

    ok
  end

  def check_unique_answer
    check_answer = Answer.where({:question_id => self.question_id,
                               :user_id => self.user_id}).first

    if !check_answer.nil? && check_answer.id != self.id
      self.errors.add(:limitation, "Your can only post one answer by question.")
      return false
    end
  end

  def on_add_vote(v, voter)
    if v > 0
      self.user.update_reputation(:answer_receives_up_vote, self.group)
      voter.on_activity(:vote_up_answer, self.group)
    else
      self.user.update_reputation(:answer_receives_down_vote, self.group)
      voter.on_activity(:vote_down_answer, self.group)
    end
  end

  def on_remove_vote(v, voter)
    if v > 0
      self.user.update_reputation(:answer_undo_up_vote, self.group)
      voter.on_activity(:undo_vote_up_answer, self.group)
    else
      self.user.update_reputation(:answer_undo_down_vote, self.group)
      voter.on_activity(:undo_vote_down_answer, self.group)
    end
  end

  def flagged!
    self.increment(:flags_count => 1)
  end


  def ban
    self.question.answer_removed!
    unsolve_question
    self.overwrite({:banned => true})
  end

  def self.ban(ids)
    self.find_each(:_id.in => ids, :select => [:question_id]) do |answer|
      answer.ban
    end
  end

  def to_html
    RDiscount.new(self.body).to_html
  end

  def disable_limits?
    self.user.present? && self.user.can_post_whithout_limits_on?(self.group)
  end

  def disallow_spam
    if new? && !disable_limits?
      eq_answer = Answer.where({:body => self.body,
                                  :question_id => self.question_id,
                                  :group_id => self.group_id
                                }).first

      last_answer  = Answer.where({:user_id => self.user_id,
                                   :question_id => self.question_id,
                                   :group_id => self.group_id}).order_by(:created_at.desc).first

      valid = (eq_answer.nil? || eq_answer.id == self.id) &&
              ((last_answer.nil?) || (Time.now - last_answer.created_at) > 20)
      if !valid
        self.errors.add(:body, "Your answer is duplicate.")
      end
    end
  end

  def add_favorite!(user)
    unless favorite_for?(user)
      self.push_uniq(:favoriter_ids => user.id)
      self.increment(:favorites_count => 1)
    end
  end

  def remove_favorite!(user)
    if favorite_for?(user)
      self.pull(:favoriter_ids => user.id)
      self.decrement(:favorites_count => 1)
    end
  end

  def favorite_for?(user)
    self.favoriter_ids && self.favoriter_ids.include?(user.id)
  end

  protected
  def unsolve_question
    if !self.question.nil? && self.question.answer_id == self.id
      self.question.set({:answer_id => nil, :accepted => false})
    end
  end
end
