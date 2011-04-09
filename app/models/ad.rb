class Ad
  include Mongoid::Document
  include MongoidExt::Slugizer

  identity :type => String

  POSITIONS = [["context_panel","context_panel"],["header","header"],["footer","footer"],["content","content"]]

  field :name, :type => String
  slug_key :name

  field :group_id, :type => String
  field :position, :type => String
  field :code, :type => String

  referenced_in :group

  before_save :set_code

  validates_presence_of     :position

  def set_code
     self[:code] = self.ad
  end

  def ad
    return
  end
end
