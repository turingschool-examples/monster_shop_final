class CreateMerchantDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :merchant_discounts do |t|
      t.references :discount, foreign_key: true
      t.references :merchant, foreign_key: true

      t.timestamps
    end
  end
end
