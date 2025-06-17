10.times.each do
  shopping_cart = ShoppingCart.create!(customer: Faker::Name.name_with_middle)
  (1..5).map do
    shopping_cart.shopping_cart_items.build(product: Faker::Commerce.product_name, price: rand(399), quantity: rand(20))
  end
  shopping_cart.save!
end