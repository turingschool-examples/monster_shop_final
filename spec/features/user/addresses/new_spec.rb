require 'rails_helper'

RSpec.describe 'New Review Creation' do
  describe 'As a registered user' do
    before :each do
        @user = User.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
        visit profile_path
        click_link "Add new address"
    end

    it "When I visit the new address form, I can fill in the fields to create a new address" do
      fill_in 'Address', with: "999 North St"
      fill_in 'City', with: "Boulder"
      fill_in 'State', with: "Colorado"
      fill_in 'Zip', with: 12345
      fill_in 'Nickname', with: "Office"
      click_button 'Add Address'
      expect(current_path). to eq(profile_path)
      save_and_open_page
    end

    it "My profile page shows my initial registration address as home, and it shows my the new address with my choesen nickname." do
      within "#addresses-#{address.nickname(0)}" do
        save_and_open_page
        expect(page).to have_content('Denver')
        expect(page).to have_content('CO')
        expect(page).to have_content( 80218)
        expect(page).to have_content( "Home")
      end

      within "#addresses-#{address.nickname(1)}" do
        expect(page).to have_content("999 North St")
        expect(page).to have_content("Boulder")
        expect(page).to have_content('CO')
        expect(page).to have_content(12345)
        expect(page).to have_content("Office")
        end
      end
    end
  end
