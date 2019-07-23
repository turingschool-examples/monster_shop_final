class AddFulfilledToOrderItems < ActiveRecord::Migration[5.1]
  def change
    add_column :order_items, :fulfilled, :boolean, default: false
  end
end
