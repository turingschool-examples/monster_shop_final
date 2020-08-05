class CreateDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.string :name
      t.integer :percent_off
      t.integer :min_quantity
      t.references :merchant, foreign_key: true

      t.timestamps
    end
  end
end
