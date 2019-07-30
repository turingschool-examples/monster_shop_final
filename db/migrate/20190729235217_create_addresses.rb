class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.string :streetname
      t.string :city
      t.string :state
      t.integer :zip
      t.integer :nickname, default: 0
      t.references :user, foreign_key: true
    end
  end
end
