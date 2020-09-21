require 'rails_helper'

#  When I click this link, I am brought to a form to create the new discount. When I submit the discount, I am taken back to my dashboard.
# If I leave a field blank, I will receive a flash message notifying me of what I need to fix.

RSpec.describe 'Merchant Dashboard' do
  describe 'As an employee of a merchant' do
    before :each do
        @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
        @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'I can see a link to add a new bulk discount' do
      visit '/merchant'

      expect(page).to have_link("Add New Discount")
    end

    it 'Will take me to a form to add a discount when clicking the "Add New Discount" link' do
      visit '/merchant'

      click_link "Add New Discount"

      expect(current_path).to eq("/merchant/discounts/new")

    end
  end
end