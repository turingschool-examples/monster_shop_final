class AddDiscountsToOrderItems < ActiveRecord::Migration[5.1]
  def change
    add_reference :order_items, :discount, foreign_key: true, null: true
  end
end
