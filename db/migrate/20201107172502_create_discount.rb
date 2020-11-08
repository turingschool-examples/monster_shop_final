class CreateDiscount < ActiveRecord::Migration[5.2]
  def change
    create_table :discounts do |t|
      t.references :merchant, foreign_key: true
      t.references :item, foreign_key: true
      t.integer :threshold
      t.float :discount
    end
  end
end
