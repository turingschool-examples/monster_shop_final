class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.string :nickname
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
    end
  end
end
