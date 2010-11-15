class Favorite
  include Mongoid::Document

  identity :type => String
  field :group_id, :type => String
  referenced_in :group

  field :user_id, :type => String
  referenced_in :user

  field :answer_id, :type => String
  referenced_in :answer

  validate :should_be_unique # FIXME
  index :user_id
  index :group_id

  protected
  def should_be_unique
    favorite = Favorite.where({:answer_id => self.answer_id,
                                :user_id     => self.user_id,
                                :group_id    => self.group_id
                               }).first

    valid = (favorite.nil? || favorite.id == self.id)
    if !valid
      self.errors.add(:favorite, "You already have this question as favorite")
    end
  end
end
