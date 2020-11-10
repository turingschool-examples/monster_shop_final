require 'rails_helper'

RSpec.describe 'Merchant Discount New Page' do
  describe 'As a Merchant employee' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'I can create a new discount' do
      name = '50% off 15 giants'
      percentage = 50
      minimum_quantity = 15

      visit "/merchant/discounts/new"

      fill_in 'Name', with: name
      fill_in 'Percentage', with: percentage
      fill_in 'Minimum Quantity', with: minimum_quantity
      click_button 'Create Discount'

      expect(current_path).to eq("/merchant/discounts")
      expect(page).to have_link(name)
      expect(page).to have_content("Discounted percentage: 50")
      expect(page).to have_content("Minimum number of items to qualify: 15")
    end
  end
end
