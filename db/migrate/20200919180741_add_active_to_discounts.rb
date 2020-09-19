class AddActiveToDiscounts < ActiveRecord::Migration[5.2]
  def change
    add_column :discounts, :active, :boolean, default: false
  end
end
