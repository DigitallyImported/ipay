module IPay
  
  def self.api_request(method, data = {})
    request = Request.new(method, data)  
    Response.new request.send
  end
  
  def self.ping
    api_request :ping
  end
  
  def self.list_permissions
    api_request :list_permissions
  end
  
  #autoload :Subscriber, 'monexa/subscriber'
end