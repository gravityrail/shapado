class TagWrapper < ModelWrapper
  def tag_url
    view_context.tag_url(@target.name)
  end
end
