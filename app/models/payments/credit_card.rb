class CreditCard
  include Mongoid::Document
  include Mongoid::Timestamps
  #include MongoidExt::Encryptor

  field :number, :type => Integer, :key => AppConfig.session_secret
  field :month, :type => Integer, :key => AppConfig.session_secret
  field :year, :type => Integer, :key => AppConfig.session_secret
  field :first_name, :type => String, :key => AppConfig.session_secret
  field :last_name, :type => String, :key => AppConfig.session_secret
  field :verification_code, :type => Integer, :key => AppConfig.session_secret

  field :email, :type => String
  field :address1, :type => String
  field :address2, :type => String
  field :country, :type => String
  field :remember, :type => Boolean, :default => false

  has_many :payments, :class_name => "Payment"

  referenced_in :account

  validates_presence_of :number
  validates_presence_of :month
  validates_presence_of :year
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :verification_code

  validates_numericality_of :number
  validates_numericality_of :month
  validates_numericality_of :year
  validates_numericality_of :verification_code

  def to_am
    ActiveMerchant::Billing::CreditCard.new(
      :number     => self.number.to_s,
      :month      => self.month.to_s,
      :year       => self.year.to_s,
      :first_name => self.first_name,
      :last_name  => self.last_name,
      :verification_value => self.verification_code.to_s
    )
  end

  def valid?
    ok = super
    if ok
      am = to_am
      ok = am.valid?
      if !ok
        self.errors.merge(am.errors.symbolize_keys)
      end
    end

    ok
  end

end
