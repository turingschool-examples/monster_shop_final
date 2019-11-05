require 'rails_helper'

RSpec.describe "Address Editing" do
  describe "As a registered user" do
    before :each do
      @user = User.create!(name: 'Megan', email: 'megan@example.com', password: 'securepassword')
      @address_1 = @user.addresses.create!(street_address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @address_2 = @user.addresses.create!(street_address: '456 Main st', city: 'Dallas', state: 'TX', zip: 75402, nickname: 'Work')
    end

    it 'I can edit my address from my profile page' do
      visit login_path
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log In'
      visit profile_path

      expect(@user.my_address).to eq(@address_1)

      within "#current-address" do
        expect(page).to have_content("Current Address: Home")
        expect(page).to have_content(@address_1.street_address)
        expect(page).to have_content("#{@address_1.city}, #{@address_1.state} #{@address_1.zip}")
        expect(page).to have_link("All Addresses")
        expect(page).to have_link("Add New Address")
        expect(page).to have_link("Edit Current Address")
        expect(page).to have_link("Delete Current Address")
        click_link 'Edit Current Address'
      end

      expect(current_path).to eq(edit_address_path(@address_1.id))

      address = '124 new str'
      city = 'new town'
      state = 'NY'
      zip = '12034'
      nickname = 'gf'

      fill_in 'street_address', with: address
      fill_in 'City', with: city
      fill_in 'State', with: state
      fill_in 'Zip', with: zip
      fill_in 'Nickname', with: nickname
      click_button 'Update Address'

      expect(current_path).to eq(profile_path)
      expect(page).to have_content("You have updated your Gf address")

      within "#current-address" do
        expect(page).to have_content("Current Address: Gf")
        expect(page).to have_content(address)
        expect(page).to have_content("#{city}, #{state} #{zip}")
        expect(page).to have_link("All Addresses")
        expect(page).to have_link("Add New Address")
        expect(page).to have_link("Edit Current Address")
        expect(page).to have_link("Delete Current Address")
      end
    end

    it 'I can edit an address from the address index page' do
      visit login_path
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log In'
      visit addresses_path

      expect(@user.my_address).to eq(@address_1)

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
        click_link 'Edit Address'
      end

      address = '124 new str'
      city = 'new town'
      state = 'NY'
      zip = '12034'

      fill_in 'street_address', with: address
      fill_in 'City', with: city
      fill_in 'State', with: state
      fill_in 'Zip', with: zip
      click_button 'Update Address'

      expect(current_path).to eq(addresses_path)
      expect(page).to have_content("You have updated your Work address")

      within "#address-#{@address_2.id}" do
        expect(page).to have_content(address)
        expect(page).to have_content(city)
        expect(page).to have_content(state)
        expect(page).to have_content(zip)
        expect(page).to have_content('Work')
        expect(page).to have_link('Set as Default Address')
        expect(page).to have_link('Delete Address')
        expect(page).to have_link('Edit Address')
      end
    end
  end
end
