class AddItemRefToDiscounts < ActiveRecord::Migration[5.2]
  def change
    add_reference :discounts, :item, foreign_key: true
  end
end
