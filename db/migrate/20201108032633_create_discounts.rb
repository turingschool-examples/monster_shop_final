class CreateDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :discounts do |t|
      t.references :merchant, foreign_key: true
      t.float :percent_off
      t.integer :item_requirement
      t.boolean :active, default: false

      t.timestamps
    end
  end
end
