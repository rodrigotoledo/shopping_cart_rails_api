# frozen_string_literal: true

FactoryBot.define do
  factory :shopping_cart do
    customer { Faker::Name.name_with_middle }
    status { "pending" }

    after(:create) do |cart|
      create_list(:shopping_cart_item, 1, shopping_cart: cart)
    end
  end
end
