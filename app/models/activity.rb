class Activity
  include Mongoid::Document
  include Mongoid::Timestamps

  ACTIONS = %w[create update destroy]

  identity :type => String

  field :action, :type => String
  field :scope, :type => Hash

  field :group_id, :type => String
  referenced_in :group

  field :user_id, :type => String
  referenced_in :user

  field :trackable_info, :type => Hash
  belongs_to :trackable, :polymorphic => true

  index :action

  before_create :store_user_name

  validates_inclusion_of :action, :in => ACTIONS, :allow_blank => false


  private
  def store_user_name
    u = User.only(:login, :name).where(:_id => self.user_id).first
    self[:login] = u[:login] || u[:name] if u
  end
end
