module IPaya
  class Flag
    attr_reader :value
    def initialize(value = nil)
      @value = value
    end
  end
end