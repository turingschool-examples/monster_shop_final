class RemoveMerchantFromDiscounts < ActiveRecord::Migration[5.2]
  def change
    remove_reference :discounts, :merchant, foreign_key: true
  end
end
