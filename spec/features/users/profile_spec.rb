require 'rails_helper'

RSpec.describe "User Profile Path" do
  describe "As a registered user" do
    before :each do
      @user = User.create!(name: 'Megan', email: 'megan@example.com', password: 'securepassword')
      @admin = User.create!(name: 'Megan', email: 'admin@example.com', password: 'securepassword', role: 2)
      @address_1 = @user.addresses.create!(street_address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218) #Default nickname should be 'Home'
      @address_2 = @user.addresses.create!(street_address: '456 Main st', city: 'Dallas', state: 'TX', zip: 75402, nickname: 'Work')
    end

    it "I can view my profile page" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit profile_path

      within "#current-address" do
        expect(page).to have_content("Current Address: Home")
        expect(page).to have_content('123 Main St')
        expect(page).to have_content("Denver, CO 80218")
        expect(page).to have_link("All Addresses")
        expect(page).to have_link("Add New Address")
        expect(page).to have_link("Edit Current Address")
        expect(page).to have_link("Delete Current Address")
      end

      expect(page).to have_content(@user.name)
      expect(page).to have_content(@user.email)
      expect(page).to_not have_content(@user.password)
      expect(page).to have_link('Edit Profile')
      expect(page).to have_link('Change Password')
    end

    it "I can update my profile data" do
      visit login_path

      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log In'

      click_link 'Edit Profile'

      expect(current_path).to eq('/profile/edit')

      name = 'New Name'
      email = 'new@example.com'

      fill_in "Name", with: name
      fill_in "Email", with: email
      click_button 'Update Profile'

      expect(current_path).to eq(profile_path)

      expect(page).to have_content('Profile has been updated!')
      expect(page).to have_content(name)
      expect(page).to have_content(email)
    end

    it "I can update my password" do
      visit login_path

      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log In'

      click_link 'Change Password'

      expect(current_path).to eq('/profile/edit_password')

      password = "newpassword"

      fill_in "Password", with: password
      fill_in "Password confirmation", with: password
      click_button 'Change Password'

      expect(current_path).to eq(profile_path)

      expect(page).to have_content('Profile has been updated!')

      click_link 'Log Out'

      visit login_path

      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log In'

      expect(page).to have_content("Your email or password was incorrect!")

      visit login_path

      fill_in 'Email', with: @user.email
      fill_in 'Password', with: "newpassword"
      click_button 'Log In'

      expect(current_path).to eq(profile_path)
    end

    it "I must use a unique email address" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit '/profile/edit'

      fill_in "Email", with: @admin.email
      click_button "Update Profile"

      expect(page).to have_content("email: [\"has already been taken\"]")
      expect(page).to have_button "Update Profile"
    end
  end
end
