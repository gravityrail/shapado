class PagesWidget < Widget
  field :settings, :type => Hash, :default => { :limit => 5, :on_welcome => true }


  def recent_pages(group)
    group.pages.paginate(:order => "created_at desc",
                         :per_page => self[:settings][:limit],
                         :page => 1,
                         :wiki => true)
  end

  protected
end
