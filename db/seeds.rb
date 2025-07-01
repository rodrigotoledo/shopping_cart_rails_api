# frozen_string_literal: true

shopping_carts = []
100.times.each do
  shopping_carts << ShoppingCart.new(customer: Faker::Name.name_with_middle)
end

ShoppingCart.import shopping_carts, validate: false, batch_size: 50

ShoppingCart.all.each do |shopping_cart|
  shopping_cart_items = []
  (1..5).map do
    shopping_cart_items << shopping_cart.shopping_cart_items.build(product: Faker::Commerce.product_name, price: rand(399), quantity: rand(20))
  end
  ShoppingCartItem.import shopping_cart_items, validate: false, batch_size: 100
end
