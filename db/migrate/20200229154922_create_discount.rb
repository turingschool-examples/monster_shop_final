class CreateDiscount < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.float :percent_off
      t.integer :quantity_threshold
      t.integer :status, default: 0
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
