require 'rails_helper'

RSpec.describe 'New Review Creation' do
  describe 'As a registered user' do
    before :each do
        @user = User.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
        visit profile_path
        click_link "Add new address"
    end
    it "When I visit the new address form, I can fillin the fields to create a new address" do
      save_and_open_page
    fill_in 'Address', with: "999 North St"
    fill_in 'City', with: "Boulder"
    fill_in 'State', with: "Colorado"
    fill_in 'Zip', with: "12345"
    fill_in 'Nickname', with: "Office"
    click_button 'Add address'
end
  end
end
