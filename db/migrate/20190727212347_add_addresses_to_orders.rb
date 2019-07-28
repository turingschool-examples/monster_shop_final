class AddAddressesToOrders < ActiveRecord::Migration[5.1]
  def change
    add_reference :orders, :address, foreign_key: true
  end
end
