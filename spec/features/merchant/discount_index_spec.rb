require 'rails_helper'

RSpec.describe 'Merchant Discount Index' do
  describe 'As a Merchant employee' do
    before :each do
      @megan_shop = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @employee = User.create!(name: 'Gaby Mendez', address: '1422 NE 20th Ave.', city: 'Gainesville', state: 'FL', zip: 32609, role: 1, email: 'employee@hotmail.com', password: 'employee', merchant_id: @megan_shop.id)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@employee)
    end

    it 'I can link to my discount page from the merchant dashboard, and show all discounts if any' do

      twenty_ten = Discount.create!(name: 'Twenty on Ten', item_minimum: 10, percent: 20, merchant_id: @megan_shop.id)

      visit '/merchant'
      click_link 'View All Discounts'

      expect(current_path).to eq('/merchant/discounts')
      expect(page).to have_content('Twenty on Ten')
    end

    it 'If there are no discounts to show, serve empty state message' do

      visit '/merchant/discounts'
      expect(page).to eq('You have no discounts available')
    end
  end
end
