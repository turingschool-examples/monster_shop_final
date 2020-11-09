require 'rails_helper'

RSpec.describe 'New Disocunt Creation' do
  describe 'As a Merchant Employee' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @user = @megan.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: 1)

      visit root_path
      within "nav" do
        click_link "Log In"
      end
      
      fill_in :email, with: @user.email
      fill_in :password, with: @user.password
      click_button "Log In"
    end

    it 'I can create a new discount for my merchant' do
      visit "/merchant/discounts/new"
      
      expect(page).to have_field("discount_percent_off")
      expect(page).to have_field("discount_item_requirement")

      fill_in "discount_percent_off", with: 20
      fill_in "discount_item_requirement", with: 0.05

      click_button 'Create Discount'
    end
  end
end
