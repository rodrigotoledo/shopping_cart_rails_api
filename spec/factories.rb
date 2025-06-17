# frozen_string_literal: true

FactoryBot.define do
  factory :shopping_cart do
    customer { Faker::Name.name }
    status { "pending" }

    after(:create) do |cart|
      create_list(:shopping_cart_item, 1, shopping_cart: cart)
    end
  end

  factory :shopping_cart_item do
    product { Faker::Commerce.product_name }
    quantity { rand(1..5) }
    price { Faker::Commerce.price(range: 10.0..200.0) }
    shopping_cart
  end
end
