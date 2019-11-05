require 'rails_helper'

RSpec.describe "Address Index" do
  describe "As a registered user" do
    before :each do
      @user = User.create!(name: 'Megan', email: 'megan@example.com', password: 'securepassword')
      @address_1 = @user.addresses.create!(street_address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @address_2 = @user.addresses.create!(street_address: '456 Main st', city: 'Dallas', state: 'TX', zip: 75402, nickname: 'Work')
    end

    it 'I can access my addresses index from the profile page and see/edit/delete all my addresses.' do

      visit login_path
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log In'
      visit profile_path

      within "#current-address" do
        click_link 'All Addresses'
      end

      expect(current_path).to eq(addresses_path)
      expect(page).to have_link('Back to My Profile')
      expect(page).to have_link('Add New Address')

      within "#address-#{@address_1.id}" do
        expect(page).to have_content("Currently used as default address.")
        expect(page).to have_content('123 Main St')
        expect(page).to have_content('Denver')
        expect(page).to have_content('CO')
        expect(page).to have_content('80218')
        expect(page).to have_content('Home')
        expect(page).to have_link('Delete Address')
        expect(page).to have_link('Edit Address')
        expect(page).to_not have_link('Set as Default Address')
      end

      within "#address-#{@address_2.id}" do
        expect(page).to have_content(@address_2.street_address)
        expect(page).to have_content(@address_2.city)
        expect(page).to have_content(@address_2.state)
        expect(page).to have_content(@address_2.zip)
        expect(page).to have_content(@address_2.nickname)
        expect(page).to have_link('Set as Default Address')
        expect(page).to have_link('Delete Address')
        expect(page).to have_link('Edit Address')
      end

      click_link 'Back to My Profile'
      expect(current_path).to eq(profile_path)
    end
  end
end
