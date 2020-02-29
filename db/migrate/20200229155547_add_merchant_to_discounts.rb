class AddMerchantToDiscounts < ActiveRecord::Migration[5.1]
  def change
    add_reference :discounts, :merchant, foreign_key: true
  end
end
