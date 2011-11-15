module IPay
  ApiError                = Class.new(RuntimeError)
  RequestError            = Class.new(ApiError)
  ResponseError           = Class.new(ApiError)
  
  # RetryRequest errors will retry immediately, failing that they will requeue
  RetryRequest            = Class.new(ResponseError)
  RequestTimeout          = Class.new(RetryRequest)
  ServiceUnavailableError = Class.new(RetryRequest)
  
  CardExpiredError        = Class.new(ResponseError)
  DeclineError            = Class.new(ResponseError)
  FraudError              = Class.new(DeclineError)
  
  class Errors
    def initialize
      @errors = {}
    end
    
    def add(*args)
      
      key, msg = *
      if args.length == 1
        [:base, args[0]]
      else
        [args[0].downcase.to_sym, args[1]]
      end
      @errors[key] = msg
    end
    
    def include?(key)
      @errors.include? key
    end
    
    def [](key)
      @errors[key]
    end
    
    def to_hash
      @errors
    end
    
    def to_a
      full_messages
    end
    
    def full_messages
      @errors.inject([]) do |ret, a|
        ret <<
        if a[0] == :base
          a[1]
        else
          "#{humanized(a[0])} #{a[1]}"
        end
        ret
      end
    end
    
    protected
    def humanized(attr)
      attr.to_s.split('_').map(&:capitalize).join(' ')
    end
    
  end
end