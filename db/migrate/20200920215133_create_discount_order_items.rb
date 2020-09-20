class CreateDiscountOrderItems < ActiveRecord::Migration[5.2]
  def change
    create_table :discount_order_items do |t|
      t.index [:discount_id, :order_item_id]
      t.index [:order_item_id, :discount_id]
      t.references :discount, foreign_key: true
      t.references :order_item, foreign_key: true
      t.timestamps
    end
  end
end
