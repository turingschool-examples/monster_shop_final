require 'rails_helper'

RSpec.describe "User Profile Path" do
  describe "As a registered user" do
    before :each do
      @user = User.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @admin = User.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'admin@example.com', password: 'securepassword')
    end

    it "I can view my profile page" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit profile_dashboard_path

      expect(page).to have_content(@user.name)
      expect(page).to have_content(@user.email)
      expect(page).to have_content(@user.address)
      expect(page).to have_content("#{@user.city} #{@user.state} #{@user.zip}")
      expect(page).to_not have_content(@user.password)
      expect(page).to have_link('Edit')
    end

    it "I can update my profile data" do
      visit login_path

      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log In'

      click_link 'Edit'

      expect(current_path).to eq("/profile/edit")

      name = 'New Name'
      email = 'new@example.com'
      address = '124 new str'
      city = 'new town'
      state = 'NY'
      zip = '12034'

      fill_in "Name", with: name
      fill_in "Email", with: email
      fill_in "Address", with: address
      fill_in "City", with: city
      fill_in "State", with: state
      fill_in "Zip", with: zip
      click_button 'Update Profile'

      expect(current_path).to eq(profile_dashboard_path)

      expect(page).to have_content('Profile has been updated!')
      expect(page).to have_content(name)
      expect(page).to have_content(email)
      expect(page).to have_content(address)
      expect(page).to have_content("#{city} #{state} #{zip}")
    end

    it "I can update my password" do
      visit login_path

      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log In'

      click_link 'Change Password'

      expect(current_path).to eq("/profile/edit")

      password = "newpassword"

      fill_in "Password", with: password
      fill_in "Password confirmation", with: password
      click_button 'Change Password'

      expect(current_path).to eq(profile_dashboard_path)

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

      expect(current_path).to eq(profile_dashboard_path)
    end

    it "I must use a unique email address" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit "/profile/edit"

      fill_in "Email", with: @admin.email
      click_button "Update Profile"

      expect(page).to have_content("email: [\"has already been taken\"]")
      expect(page).to have_button "Update Profile"
    end
  end
end
