class DropUserAddresses < ActiveRecord::Migration[5.1]
  def up
    drop_table :user_addresses
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
