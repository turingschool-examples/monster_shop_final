class CreateDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.integer :amount
      t.integer :num_items
      
      t.timestamps
    end
  end
end
