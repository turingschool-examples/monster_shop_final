# frozen_string_literal: true

class AddMerchantToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :merchant, foreign_key: true
  end
end
