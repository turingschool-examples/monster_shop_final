require 'rails_helper'

RSpec.describe "Full Address CRUD" do
  describe "As a Registered User" do
    before :each do
      @user = User.create!(name: 'Megan', email: 'megan@example.com', password: 'securepassword')
      @user_address = @user.addresses.create!(address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      visit login_path

      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log In'
    end
    it "Users can Edit an address from their profile page" do
      visit profile_path

      expect(page).to have_link("Edit This Address")
      click_on "Edit This Address"

      expect(current_path).to eq(edit_user_address_path(@user_address))
      expect(page).to have_content("Edit Address Form")
    end
    it "Users can Create an address from their profile page" do
      visit profile_path

      expect(page).to have_link("Create A New Address")
      click_on "Create A New Address"

      expect(current_path).to eq(new_user_address_path(@user))
      expect(page).to have_content("New Address Form")

      fill_in "Address", with: "123 Tree St"
      fill_in "City", with: "Chicago"
      fill_in "State", with: "FL"
      fill_in "Zip", with: "80237"

      click_on "Create Address"
      expect(current_path).to eq(profile_path)
    end
    it "Users can Delete an address from their profile page" do
      visit profile_path

      expect(page).to have_link("Delete This Address")
      click_on "Delete This Address"

      expect(current_path).to eq(profile_path)
      expect(page).to_not have_content(@user_address.address)
      expect(page).to_not have_content(@user_address.city)
      expect(page).to_not have_content(@user_address.state)
      expect(page).to_not have_content(@user_address.zip)
    end
  end
end
