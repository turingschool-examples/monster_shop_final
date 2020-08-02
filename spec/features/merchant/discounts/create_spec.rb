require 'rails_helper'

RSpec.describe 'Merchant Discount Index Page' do
  describe 'As an employee of a merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it "I can create a new discount" do
      percent = 15
      quantity = 30
      
      visit '/merchant/discounts'

      click_on "Create A Discount"

      expect(current_path).to eq('/merchant/discounts/new')

      fill_in "Percent Off", with: percent
      fill_in "Item Quantity", with: quantity
      click_on "Create Discount"

      new_discount = Discount.last

      expect(current_path).to eq('/merchant/discounts')

      expect(page).to have_content('Discount successfully created')

      within ".discount-#{new_discount.id}" do
        expect(page).to have_content("Discount ID: #{new_discount.id}")
        expect(page).to have_content("Percent Off: #{new_discount.percent}")
        expect(page).to have_content("Required Item Quantity: #{new_discount.quantity} units")
      end
    end
  end
end
