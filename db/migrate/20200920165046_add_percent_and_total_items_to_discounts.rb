class AddPercentAndTotalItemsToDiscounts < ActiveRecord::Migration[5.2]
  def change
    add_column :discounts, :percent, :integer, default: 0
    add_column :discounts, :min_items, :integer, default: 0
  end
end
