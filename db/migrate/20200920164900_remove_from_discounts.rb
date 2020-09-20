class RemoveFromDiscounts < ActiveRecord::Migration[5.2]
  def change
    remove_column :discounts, :name
  end
end
