require 'rails_helper'

RSpec.describe 'New Address Creation' do
  before :each do
    @user = User.create(name: 'Megan', email: 'megan@example.com', password: 'securepassword')
  end

  it 'I can add a new address' do
    visit login_path

    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Log In'
    expect(current_path).to eq(profile_path)

    click_link 'Add Address'
    expect(current_path).to eq(new_user_address_path(@user.id))

  end
end
