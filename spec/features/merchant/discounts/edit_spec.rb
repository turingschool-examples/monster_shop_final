require 'rails_helper'

RSpec.describe 'Merchant Dashboard' do
  describe 'As an employee of a merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: 1)
      @discount1 = @merchant_1.discounts.create!(percent_off: 0.10, item_requirement: 5)
      @discount2 = @merchant_1.discounts.create!(percent_off: 0.20, item_requirement: 10)
      visit root_path

      within "nav" do
        click_link "Log In"
      end
      
      fill_in :email, with: @user.email
      fill_in :password, with: @user.password
      click_button "Log In"
    end 
    
    it 'I am able to edit the details of my discount' do
      visit "/merchant/#{@merchant_1.id}/discounts/#{@discount1.id}/edit"
      expect(page).to have_field("discount_percent_off")
      expect(page).to have_field("discount_item_requirement")
      
      fill_in "discount_percent_off", with: 0.15
      fill_in "discount_item_requirement", with: 15
      
      click_button 'Update Discount'

      expect(current_path).to eq("/merchant/#{@merchant_1.id}/discounts/index")

      within "#discount-#{@discount1.id}" do
        expect(page).to have_content("Get 15% off of orders of 15 items or more")
      end 
    end
  end 
end