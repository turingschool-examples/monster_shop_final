class ChangeNicknameDefault < ActiveRecord::Migration[5.1]
  def change
    change_column :addresses, :nickname, :string, default: 'Home'
  end
end
