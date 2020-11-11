class AddLimitToDiscounts < ActiveRecord::Migration[5.2]
  def change
    add_column :discounts, :limit, :integer
  end
end
