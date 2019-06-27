class UpdateItems < ActiveRecord::Migration[5.1]
  def change
    change_column_default :items, :active, true
  end
end
