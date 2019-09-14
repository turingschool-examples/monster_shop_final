class RemoveFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :address
    remove_column :users, :city
    remove_column :users, :state
    remove_column :users, :zip
  end
end
