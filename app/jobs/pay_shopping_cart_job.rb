# frozen_string_literal: true

class PayShoppingCartJob < ApplicationJob
  queue_as :default

  def perform(shopping_cart_id)
    shopping_cart = ShoppingCart.find(shopping_cart_id)
    shopping_cart.paid!
    ApiFront::ShoppingCart.touch(shopping_cart_id)
  rescue => e
    logger.info e.inspect
    false
  end
end
