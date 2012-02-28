class ShapadoVersion
  include Mongoid::Document

  field :token, :type => String, :index => true
  field :price, :type => Integer

  field :page_views, :type => Integer
  field :custom_ads, :type => Boolean
  field :custom_js, :type => Boolean
  field :custom_domain, :type => Boolean
  field :private, :type => Boolean
  field :custom_themes, :type => Boolean
  field :basic_support, :type => Boolean
  field :phone_support, :type => Boolean


  references_many :groups, :validate => false

  validates_presence_of :token, :price
  validates_uniqueness_of :token

  def name
    I18n.t("versions.#{token}")
  end

  def in_dollars
    self.price / 100.0
  end

  def self.reload!
    versions_data = YAML.load_file("#{Rails.root}/config/versions.yml")

    versions_data.each do |token, data|
      version = ShapadoVersion.where(:token => token).first
      if version.nil?
        version = ShapadoVersion.create!(data.merge(:token => token))
        Stripe.api_key = PaymentsConfig['secret']
        Stripe::Plan.create(
          :amount => version.price,
          :interval => 'month',
          :name => version.token.titleize,
          :currency => 'usd',
          :id => version.token
        )
      else
        version.update_attributes(data)
      end
    end
  end
end
