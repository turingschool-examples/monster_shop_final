class CreateDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.string :name
      t.integer :item_minimum
      t.integer :percent
      t.references :merchant, foreign_key: true

      t.timestamps
    end
  end
end
