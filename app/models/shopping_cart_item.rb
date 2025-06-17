# frozen_string_literal: true

class ShoppingCartItem < ApplicationRecord
  belongs_to :shopping_cart
end
