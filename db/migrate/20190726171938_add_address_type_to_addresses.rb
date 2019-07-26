class AddAddressTypeToAddresses < ActiveRecord::Migration[5.1]
  def change
    add_column :addresses, :address_type, :integer, default: 0
  end
end
