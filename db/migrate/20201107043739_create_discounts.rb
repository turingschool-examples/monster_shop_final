class CreateDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :discounts do |t|
      t.string :description
      t.integer :quantity
      t.integer :percent
      t.boolean :enable, default: true
      t.timestamps
    end
  end
end
