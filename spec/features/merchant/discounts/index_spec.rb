require 'rails_helper'

RSpec.describe 'Merchant Dashboard' do
  describe 'As an employee of a merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: 1)
    end 

    it 'I see a link to add a new discount' do
      visit "/merchant/#{@merchant_1.id}/discounts/index"

      expect(page).to have_link("Create a Bulk Discount")
      click_link("Create a Bulk Discount")

      
      expect(current_path).to eq("/merchant/discounts/new")

    end 
  end 
end