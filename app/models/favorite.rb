class Favorite
  include Mongoid::Document

  identity :type => String
  field :group_id, :type => String, :index => true
  referenced_in :group

  field :user_id, :type => String, :index => true
  referenced_in :user

  field :question_id, :type => String
  referenced_in :question

  validate :should_be_unique # FIXME

  protected
  def should_be_unique
    favorite = Favorite.first({:question_id => self.question_id,
                                :user_id     => self.user_id,
                                :group_id    => self.group_id
                               })

    valid = (favorite.nil? || favorite.id == self.id)
    if !valid
      self.errors.add(:favorite, "You already have this question as favorite")
    end
  end
end
