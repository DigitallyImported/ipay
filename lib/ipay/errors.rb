module IPay
  ApiError        = Class.new(RuntimeError)
  
  RequestError    = Class.new(ApiError)
  RequestTimeout  = Class.new(RequestError)
  
  ResponseError   = Class.new(ApiError)
end