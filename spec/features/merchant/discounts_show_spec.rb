require 'rails_helper'

RSpec.describe 'Merchant Discount Show' do
  describe 'As a Merchant employee' do
    before :each do
      @megan_shop = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @employee = User.create!(name: 'Gaby Mendez', address: '1422 NE 20th Ave.', city: 'Gainesville', state: 'FL', zip: 32609, role: 1, email: 'employee@hotmail.com', password: 'employee', merchant_id: @megan_shop.id)

      @twenty_ten = Discount.create!(name: 'Twenty on Ten', item_minimum: 10, percent: 20, merchant_id: @megan_shop.id)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@employee)
    end

    it 'I see that each Discount name on the index page is a link to its show page' do

      visit '/merchant/discounts'
      click_link 'Twenty on Ten'

      expect(current_path).to eq("/merchant/discounts/#{@twenty_ten.id}")
      expect(page).to have_content('Twenty on Ten')
      expect(page).to have_content('20% off on 10 items or more!')
    end
  end
end
