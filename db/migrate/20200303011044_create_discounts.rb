class CreateDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.string :title
      t.integer :percent_off
      t.string :information
      t.integer :lowest_amount
      t.integer :highest_amount
      t.references :merchant, foreign_key: true
    end
  end
end
