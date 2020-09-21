require 'rails_helper'

RSpec.describe 'New discount form' do
  describe 'As an employee of a merchant' do
    before :each do
        @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
        @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
        
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'Will allow me to create a new discount' do
      visit '/merchant/discounts/new'

      fill_in "Threshold quantity", with: 10
      fill_in "Discount percentage", with: 5

      click_button "Submit New Discount"
      
      expect(current_path).to eq("/merchant")

      expect(page).to have_content("Discount Quantity")
      expect(page).to have_content("10")
      expect(page).to have_content("Discount Percentage")
      expect(page).to have_content("5")
      expect(page).to have_button("Delete Discount")
      expect(page).to have_button("Update Discount")

    end

    it 'Will not allow me to leave a field empty' do
      visit '/merchant/discounts/new'

      fill_in "Threshold quantity", with: 10
      fill_in "Discount percentage", with: ""

      click_button "Submit New Discount"
      expect(page).to have_content("Discount percentage can't be blank")

      fill_in "Discount percentage", with: 5.0
      click_button "Submit New Discount"
      expect(current_path).to eq("/merchant")

    end
  end
end