class AddAddressesToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :address, foreign_key: true
  end
end
