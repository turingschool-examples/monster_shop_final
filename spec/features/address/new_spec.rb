require 'rails_helper'

RSpec.describe 'Create New Address' do
  before :each do
    @user = User.create!(name: 'Megan', email: 'megan@example.com', password: 'securepassword')
    @address_1 = Address.create!(nickname: 'Home', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, user_id: @user.id)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  describe 'As a registered user when I visit my profile page' do
    it 'I see a link to create a new address and give it a nickname' do
      visit profile_path

      expect(current_path).to eq('/profile')

      click_link 'Create New Address'

      expect(current_path).to eq(new_address_path)

      fill_in 'Nickname', with: 'Work'
      fill_in 'Address', with: '1776 Independence'
      fill_in 'City', with: 'Boston'
      fill_in 'State', with: 'MA'
      fill_in 'Zip', with: '80218'
      click_button 'Create Address'

      address_2 = Address.last

      expect(current_path).to eq(profile_path)

      within "#address-#{address_2.id}" do
        expect(page).to have_content("Nickname: Work")
        expect(page).to have_content("Address: 1776 Independence")
        expect(page).to have_content("Boston")
        expect(page).to have_content("MA")
        expect(page).to have_content("80218")
      end
    end
  end
end
