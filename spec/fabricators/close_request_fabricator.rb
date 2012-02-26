Fabricator(:close_request) do
  reason { CloseRequest::REASONS[rand()*CloseRequest::REASONS.size]}
end
