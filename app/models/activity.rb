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

  def to_activity_stream
    url_helper = Rails.application.routes.url_helpers
    domain = self.group.domain

    {
      "postedTime" => self.created_at.xmlschema,
      "actor" => {
        "url" => url_helper.user_url(self.user, :host => self.group.domain),
        "objectType" => "person",
        "id" => "tag:#{domain},#{Time.now.year}:#{self.user.id}",
        "image" => {
          "url" => "#{domain}/_files/users/big/#{self.user.id}",
          "width" => 250,
          "height" => 250
        },
        "displayName" => self.user.name || self.user.login
      },
      "verb" => self.action,
      "object" => {
        "url" => url_for_trackable(domain),
        "id" => "tag:#{domain},#{Time.now.year}:#{self.trackable_id}"
      },
      "target" => {
        "url" => "#{domain}",
        "objectType" => "group",
        "id" => "tag:#{domain},2011:#{self.group_id}",
        "displayName" => self.group.name
      }
    }
  end

  private
  def store_user_name
    u = User.only(:login, :name).where(:_id => self.user_id).first
    self[:login] = u[:login] || u[:name] if u
  end

  def url_for_trackable(domain)
    url_helper = Rails.application.routes.url_helpers

    case self.trackable_type.to_s
    when "Question"
      url_helper.question_path(self.trackable, :host => domain)
    when "Answer"
      url_helper.question_answer_path(self.trackable.question, self.trackable, :host => domain)
    when "Page"
      url_helper.page_path(self.trackable, :host => domain)
    when "User"
      url_helper.user_path(self.trackable, :host => domain)
    else
      raise ArgumentError, "#{self.trackable_type} is not handled yet"
    end
  end
end
