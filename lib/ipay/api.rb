module IPay
  
  def self.api_request(data = {})
    request = Request.new(data)  
    Response.new request.send
  end
 
  #autoload :Subscriber, 'monexa/subscriber'
end