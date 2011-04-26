module IPaya
  module Plan
    def self.list(data)
      api_request :list_plans, data
    end
  end
end