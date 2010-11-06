class Announcement
  include Mongoid::Document
  include Mongoid::Timestamps

  identity :type => String

  field :message, :type => String, :required => true
  field :starts_at, :type => Timestamp, :required => true
  field :ends_at, :type => Timestamp, :required => true

  field :only_anonymous, :type => Boolean, :default => false

  referenced_in :group

  validate :check_dates

  protected
  def check_dates
    if self.starts_at < Time.now.yesterday
      self.errors.add(:starts_at, "Starting date should be setted to a future date")
    end

    if self.ends_at <= self.starts_at
      self.errors.add(:ends_at, "Ending date should be greater than starting date")
    end
  end
end
