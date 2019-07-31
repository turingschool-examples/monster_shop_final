require 'rails_helper'

RSpec.describe 'Edit an Address' do
  describe 'As a User' do
    before :each do

      @user = User.create!(name: 'Megan', email: 'megan_1@example.com', password: 'securepassword')
      @user_address_1 = @user.addresses.create!(street_address: '123 user lives here', city: 'Denver', state: 'CO', zip: 80301)
      @user_address_2 = @user.addresses.create!(street_address: 'The Big Oak Tree Out Back', city: 'Burlington', state: 'VT', zip: 1234, nickname: "Clubhouse")
      @user_address_3 = @user.addresses.create!(street_address: 'No Roads! Just leave it by the big stump.', city: 'Forest', state: 'MT', zip: 45677, nickname: "Mountain Getaway")
    end
    it ' I can edit my addresses' do
      visit registration_path
      fill_in 'Name', with: 'Megan'
      fill_in 'Street address', with: '123 Main St'
      fill_in 'City', with: 'Denver'
      fill_in 'State', with: 'CO'
      fill_in 'Zip', with: '80218'
      fill_in 'Email', with: 'megan@example.com'
      fill_in 'Password', with: 'securepassword'
      fill_in 'Password confirmation', with: 'securepassword'
      click_button 'Register'
      expect(current_path).to eq(profile_path)
      expect(page).to have_content('Welcome, Megan!')

      click_on "Edit My Address"


      # expect(current_path).to eq(user_addresses_path)

      fill_in 'Street address', with: 'Edited Address'
      fill_in 'City', with: 'Edited'
      fill_in 'State', with: 'Edited'
      fill_in 'Zip', with: 'Edited'

      click_on 'Update Address'


    end
  end
end
