module ApiFront
  class ShoppingCart < ActiveResource::Base
    self.include_format_in_path = false
    self.site = "http://localhost:3001"
    def self.touch(id)
      put("#{id}/touch")
    end
  end
end