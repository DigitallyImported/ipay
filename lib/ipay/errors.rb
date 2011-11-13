module IPay
  ApiError                = Class.new(RuntimeError)
  RequestError            = Class.new(ApiError)
  ResponseError           = Class.new(ApiError)
  
  # RetryRequest errors will retry immediately, failing that they will requeue
  RetryRequest            = Class.new(ResponseError)
  RequestTimeout          = Class.new(RetryRequest)
  ServiceUnavailableError = Class.new(RetryRequest)
  
  DeclineError            = Class.new(ResponseError)
  FraudError              = Class.new(DeclineError)
end