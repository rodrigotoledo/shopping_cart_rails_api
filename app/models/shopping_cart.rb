class ShoppingCart < ApplicationRecord
  enum :status, [:pending, :paid]
  has_many :shopping_cart_items
  accepts_nested_attributes_for :shopping_cart_items

  def pay
    PayShoppingCartJob.perform_later(id)
  end
end
