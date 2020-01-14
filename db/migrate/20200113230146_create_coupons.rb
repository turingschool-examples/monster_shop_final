class CreateCoupons < ActiveRecord::Migration[5.1]
  def change
    create_table :coupons do |t|
      t.string :name
      t.integer :code
      t.integer :percentage

      t.references :merchant, foreign_key: true
      t.timestamps
    end
  end
end
