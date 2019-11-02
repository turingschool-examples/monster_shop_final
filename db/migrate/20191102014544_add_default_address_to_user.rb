class AddDefaultAddressToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :default_address, :bigint
  end
end
