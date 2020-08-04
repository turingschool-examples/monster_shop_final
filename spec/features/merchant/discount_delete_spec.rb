require 'rails_helper'

RSpec.describe 'Merchant Discount Delete' do
  describe 'As a Merchant employee' do
    before :each do
      @megan_shop = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @employee = User.create!(name: 'Gaby Mendez', address: '1422 NE 20th Ave.', city: 'Gainesville', state: 'FL', zip: 32609, role: 1, email: 'employee@hotmail.com', password: 'employee', merchant_id: @megan_shop.id)

      @twenty_ten = Discount.create!(name: 'Twenty on Ten', item_minimum: 10, percent: 20, merchant_id: @megan_shop.id)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@employee)
    end

    it 'I see that on a Discount\'s show page, I see a button to delete that discount; when I click it, I\'m taken back to the discount index page where I no longer see the deleted discount info' do

      visit "/merchant/discounts/#{@twenty_ten.id}"
      click_button 'Delete'

      expect(current_path).to eq("/merchant/discounts")

      expect(page).to_not have_content('Twenty on Ten')
      expect(page).to have_content('Your discount has been deleted.')
    end
  end
end
