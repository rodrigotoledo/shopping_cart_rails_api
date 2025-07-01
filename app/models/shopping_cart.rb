# frozen_string_literal: true

class ShoppingCart < ApplicationRecord
  enum :status, [ :pending, :paid ]
  has_many :shopping_cart_items
  accepts_nested_attributes_for :shopping_cart_items
  validates :customer, presence: true

  def pay
    PayShoppingCartJob.perform_async(id)
  end
end
