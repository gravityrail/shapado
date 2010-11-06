class Ad
  include Mongoid::Document
  include MongoidExt::Slugizer

  POSITIONS = [["context_panel","context_panel"],["header","header"],["footer","footer"],["content","content"]]

  key :name
  slug_key :name

  key :group_id, String
  key :position, String
  key :code, String

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
