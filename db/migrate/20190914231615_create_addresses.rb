class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.string :address
      t.string :city
      t.string :state
      t.integer :zip
      t.string :nickname

      t.timestamps
    end
  end
end
