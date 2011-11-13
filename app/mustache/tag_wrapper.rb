class TagWrapper < ModelWrapper
  def tag_url
    view_context.tag_url(@target.name)
  end

  def count
    @target.count.to_i
  end

  def followers_count
    @target.followers_count.to_i
  end
end
