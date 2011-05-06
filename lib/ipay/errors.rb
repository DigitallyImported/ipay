module IPay
  ApiError      = Class.new(RuntimeError)
  RequestError  = Class.new(ApiError)
  ResponseError = Class.new(ApiError)
end