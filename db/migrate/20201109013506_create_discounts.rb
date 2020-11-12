class CreateDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :discounts do |t|
      t.string :name, default: nil
      t.float :percentage, default: nil
    end
  end
end
