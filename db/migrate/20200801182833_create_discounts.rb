class CreateDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.float :percent
      t.integer :req_inventory
      t.timestamps
    end
  end
end
