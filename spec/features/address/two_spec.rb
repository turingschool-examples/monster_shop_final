require 'rails_helper'

RSpec.describe "Full Address CRUD" do
  describe "As a Registered User" do
    before :each do
      @user = User.create!(name: 'Megan', email: 'megan@example.com', password: 'securepassword')
      @user_address = @user.addresses.create!(address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end
    it "Users can Edit an address from their profile page" do
      visit profile_path

      expect(page).to have_link("Edit This Address")
    end
    it "Users can Create an address from their profile page" do
      visit profile_path

      expect(page).to have_link("Create A New Address")
    end
    it "Users can Delete an address from their profile page" do
      visit profile_path

      expect(page).to have_link("Delete This Address")
    end
  end
end
