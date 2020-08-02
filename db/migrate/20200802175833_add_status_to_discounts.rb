class AddStatusToDiscounts < ActiveRecord::Migration[5.1]
  def change
    add_column :discounts, :status, :integer, default: 0
  end
end
