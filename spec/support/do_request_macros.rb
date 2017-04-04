module DoRequestMacros
  def do_request(type, path, options = {})
    send type, path, {format: :json}.merge(options)
  end
end