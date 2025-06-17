class CreateShoppingCarts < ActiveRecord::Migration[8.0]
  def change
    create_table :shopping_carts do |t|
      t.string :customer
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
