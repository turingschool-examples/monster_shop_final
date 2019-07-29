require 'rails_helper'

RSpec.describe 'Edit User Address' do
  before :each do
    @user = User.create!(name: 'Megan', email: 'megan@example.com', password: 'securepassword')
    @address_1 = Address.create!(nickname: 'Home', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, user_id: @user.id)

    visit login_path

    fill_in 'Email', with: 'megan@example.com'
    fill_in 'Password', with: 'securepassword'
    click_button 'Log In'
  end
  describe 'As a registered user' do
    describe 'I see a link to edit each address I have in the system' do
      it 'When I click the link I am taken to a prepopulated form where I can make changes' do
        visit profile_path

        expect(current_path).to eq('/profile')

        within "#address-#{@address_1.id}" do
          click_link 'Edit Address'
        end

        expect(current_path).to eq(edit_address_path(@address_1.id))

        expect(page).to have_field('Nickname', with: 'Home')
        expect(page).to have_field('Address', with: '123 Main St')
        expect(page).to have_field('City', with: 'Denver')
        expect(page).to have_field('State', with: 'CO')
        expect(page).to have_field('Zip', with: '80218')

        fill_in 'Address', with: '1776 Independence'
        fill_in 'City', with: 'Boston'
        fill_in 'State', with: 'MA'
        click_button 'Update Address'

        expect(current_path).to eq(profile_path)

        within "#address-#{@address_1.id}" do
          expect(page).to have_content("Nickname: Home")
          expect(page).to have_content("Address: 1776 Independence")
          expect(page).to have_content("Boston")
          expect(page).to have_content("MA")
          expect(page).to have_content("80218")
        end
      end
    end
  end

  describe 'Update address with missing fields' do
    it 'I get an error message if I do not fill in all address fields' do
      visit profile_path

      expect(current_path).to eq('/profile')

      within "#address-#{@address_1.id}" do
        click_link 'Edit Address'
      end

      expect(current_path).to eq(edit_address_path(@address_1.id))

      expect(page).to have_field('Nickname', with: 'Home')
      expect(page).to have_field('Address', with: '123 Main St')
      expect(page).to have_field('City', with: 'Denver')
      expect(page).to have_field('State', with: 'CO')
      expect(page).to have_field('Zip', with: '80218')

      fill_in 'Address', with: ''
      fill_in 'City', with: 'Boston'
      fill_in 'State', with: 'MA'
      click_button 'Update Address'

      expect(page).to have_content("address: [\"can't be blank\"]")
      expect(page).to_not have_link('Edit Address')
    end
  end
end
