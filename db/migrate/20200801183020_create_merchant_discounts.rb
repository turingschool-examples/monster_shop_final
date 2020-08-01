class CreateMerchantDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :merchant_discounts do |t|
      t.references :merchant, foreign_key: true
      t.references :discount, foreign_key: true
    end
  end
end
