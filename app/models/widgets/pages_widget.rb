class PagesWidget < Widget
  validate :set_name, :on => :create
  field :settings, :type => Hash, :default => { :limit => 5, :on_welcome => true }


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
