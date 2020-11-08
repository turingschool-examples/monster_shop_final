class ChangeNameOfColumn < ActiveRecord::Migration[5.2]
  def change
    rename_column :discounts, :items_req, :items_required
  end
end
