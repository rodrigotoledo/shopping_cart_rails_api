# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "/shopping_carts", type: :request do
  describe "GET /index" do
    it "returns a list of shopping carts" do
      FactoryBot.create_list(:shopping_cart, 2)
      get shopping_carts_path
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).length).to eq(2)
    end
  end

  describe "GET /show" do
    it "returns a single shopping cart" do
      cart = FactoryBot.create(:shopping_cart)
      get shopping_cart_path(cart.id)
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["id"]).to eq(cart.id)
    end

    it "returns unprocessable_entity" do
      cart = FactoryBot.create(:shopping_cart)
      allow_any_instance_of(ShoppingCart).to receive(:as_json).and_raise(StandardError)
      get shopping_cart_path(cart.id)
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PUT /shopping_carts/:id/pay" do
    let(:cart) { FactoryBot.create(:shopping_cart) }

    it "marks the cart as paid" do
      PayShoppingCartJob.clear

      expect {
        put pay_shopping_cart_path(cart.id)
      }.to change { PayShoppingCartJob.jobs.size }.by(1)

      expect(PayShoppingCartJob.jobs.last['args']).to eq([ cart.id ])
      expect(response).to have_http_status(:ok)
    end

    it "returns unprocessable_entity when cart is already paid" do
      paid_cart = FactoryBot.create(:shopping_cart, status: "paid")
      PayShoppingCartJob.clear

      expect {
        put pay_shopping_cart_path(paid_cart.id)
      }.not_to change { PayShoppingCartJob.jobs.size }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "GET /shopping_carts/paids" do
    it "returns only paid shopping carts" do
      FactoryBot.create(:shopping_cart, status: "paid")
      FactoryBot.create(:shopping_cart, status: "pending")
      get paids_shopping_carts_path
      json = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json.length).to eq(1)
      expect(json.first["status"]).to eq("paid")
    end
  end
end
