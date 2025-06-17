# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApiFront::ShoppingCart, type: :model do
  describe ".touch" do
    it "Makes a Put request for /:id/touch" do
      stub = stub_request(:put, "http://localhost:3001/shopping_carts/123/touch").
         with(
           headers: {
       	  'Accept'=>'*/*',
       	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	  'Content-Type'=>'application/json',
       	  'User-Agent'=>'Ruby'
           }).
         to_return(status: 200, body: "", headers: {})

      described_class.touch(123)

      expect(stub).to have_been_requested
    end
  end
end
