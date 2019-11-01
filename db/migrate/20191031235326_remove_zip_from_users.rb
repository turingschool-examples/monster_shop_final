class RemoveZipFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :zip, :integer
  end
end
