class PagesWidget < Widget
  field :settings, :type => Hash, :default => { :limit => 5}


  def recent_pages(group)
    group.pages.order_by(:created_at.desc).where(:wiki => true).paginate(:per_page => self[:settings]['limit'], :page => 1)
  end

  protected
end
