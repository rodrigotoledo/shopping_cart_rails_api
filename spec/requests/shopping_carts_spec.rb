# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "/shopping_carts", type: :request do
  let(:valid_attributes) do
    {
      customer: Faker::Name.name,
      shopping_cart_items_attributes: [
        {
          product: Faker::Commerce.product_name,
          quantity: rand(1..3),
          price: Faker::Commerce.price(range: 10.0..100.0)
        }
      ]
    }
  end

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
  end

  describe "POST /create" do
    it "creates a new shopping cart" do
      expect {
        post shopping_carts_path, params: { shopping_cart: valid_attributes }
      }.to change(ShoppingCart, :count).by(1)

      expect(response).to have_http_status(:created)
    end
  end

  describe "PUT /update" do
    it "updates an existing shopping cart" do
      cart = FactoryBot.create(:shopping_cart)
      new_customer = "Updated Customer"
      put shopping_cart_path(cart.id), params: { shopping_cart: { customer: new_customer } }
      expect(response).to have_http_status(:ok)
      expect(cart.reload.customer).to eq(new_customer)
    end
  end

  describe "PUT /shopping_carts/:id/pay" do
    it "marks the cart as paid" do
      cart = FactoryBot.create(:shopping_cart)
      expect(cart.status).not_to eq("paid")
      expect {
        put pay_shopping_cart_path(cart.id)
      }.to have_enqueued_job(PayShoppingCartJob).with(cart.id)

      expect(response).to have_http_status(:ok)
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
