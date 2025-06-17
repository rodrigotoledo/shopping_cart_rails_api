# frozen_string_literal: true

class CreateShoppingCartItems < ActiveRecord::Migration[8.0]
  def change
    create_table :shopping_cart_items do |t|
      t.references :shopping_cart, null: false, foreign_key: true
      t.string :product
      t.integer :quantity
      t.float :price

      t.timestamps
    end
  end
end
