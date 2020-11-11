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

    it 'I see a link to manage my discounts' do
      visit "/merchant/#{@merchant_1.id}/discounts/index"

      expect(page).to have_link("Create a Bulk Discount")
      click_link("Create a Bulk Discount")

      expect(current_path).to eq("/merchant/discounts/new")
    end 

    it 'I see each of my discounts with a button to edit that discount' do
      visit "/merchant/#{@merchant_1.id}/discounts/index"
    
      expect(page).to have_content("Get #{@discount1.percentage_display}% off of orders of #{@discount1.item_requirement} items or more")
      expect(page).to have_content("Get #{@discount2.percentage_display}% off of orders of #{@discount2.item_requirement} items or more")
      within "#discount-#{@discount1.id}" do
        click_button("Edit Discount")
      end 

      expect(current_path).to eq("/merchant/#{@merchant_1.id}/discounts/#{@discount1.id}/edit")
    end

    it 'I see each of my discounts with a button to delete that discount' do
      visit "/merchant/#{@merchant_1.id}/discounts/index"

      within "#discount-#{@discount1.id}" do
        click_button("Delete Discount")
      end 
    
      expect(current_path).to eq("/merchant/#{@merchant_1.id}/discounts/index")
      expect(page).to_not have_content("Get #{@discount1.percentage_display}% off of orders of #{@discount1.item_requirement} items or more")
    end
  end 
end