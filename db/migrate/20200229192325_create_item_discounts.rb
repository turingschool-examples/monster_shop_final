class CreateItemDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :item_discounts do |t|
      t.references :item, foreign_key: true
      t.references :discount, foreign_key: true
      t.integer :amount
      t.integer :num_items
    end
  end
end
