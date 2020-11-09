class CreateDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :discounts do |t|
      t.string :name
      t.integer :percentage
      t.integer :minimum_quantity
      t.references :item, foreign_key: true

      t.timestamps
    end
  end
end
