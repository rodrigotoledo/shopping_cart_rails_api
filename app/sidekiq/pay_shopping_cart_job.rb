# frozen_string_literal: true

class PayShoppingCartJob
  include Sidekiq::Job

  def perform(shopping_cart_id)
    shopping_cart = ShoppingCart.find(shopping_cart_id)
    shopping_cart.paid!
    ApiFront::ShoppingCart.touch(shopping_cart_id)
  rescue => e
    false
  end
end
