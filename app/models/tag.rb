class Tag
  include Mongoid::Document
  include Mongoid::Timestamps
  include MongoidExt::Storage

  identity :type => String

  field :name,  :type => String
  field :description, :type => String
  field :count, :type => Float, :default => 0.0
  field :langs, :type => Array
  field :color, :type => String

  file_key :logo, :max_length => 1.megabytes

  referenced_in :group

  index :name
  index :group_id
end
