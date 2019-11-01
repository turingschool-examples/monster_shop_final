class RemoveStateFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :state, :string
  end
end
