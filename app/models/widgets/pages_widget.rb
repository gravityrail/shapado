class PagesWidget < Widget
  before_validation_on_create :set_name
  before_validation_on_update :set_name
  key :settings, Hash, :default => { :limit => 5 }

  def recent_pages(group)
    group.pages.paginate(:order => "created_at desc",
                         :per_page => self[:settings][:limit],
                         :page => 1,
                         :wiki => true)
  end

  protected
  def set_name
    self[:name] ||= "pages"
  end
end
