class Version
  include Mongoid::Document

  identity :type => String
  field :data, :type => Hash
  field :message, :type => String
  field :date, :type => Time

  field :user_id, :type => String
  referenced_in :user

  def content(key)
    cdata = self.data[key]
    if cdata.respond_to?(:join)
      cdata.join(" ")
    else
      cdata || ""
    end
  end
end
