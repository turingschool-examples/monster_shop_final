class CreateDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :discounts do |t|
      t.integer :quantity
      t.integer :discount

      t.timestamps
    end
  end
end
