require 'rails_helper'

RSpec.describe 'Merchant Discount Creation' do
  describe 'As a Merchant employee' do
    before :each do
      @megan_shop = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @employee = User.create!(name: 'Gaby Mendez', address: '1422 NE 20th Ave.', city: 'Gainesville', state: 'FL', zip: 32609, role: 1, email: 'employee@hotmail.com', password: 'employee', merchant_id: @megan_shop.id)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@employee)
    end

    it 'I can create a new discount from my discounts index page' do

      visit '/merchant/discounts'
      click_link 'New Discount'
      expect(current_path).to eq('/merchant/discounts/new')

      fill_in 'Name', with: 'Five on Five'
      fill_in 'Item minimum', with: 5
      fill_in 'Percent', with: 5
      click_on 'Create Discount'

      expect(current_path).to eq('/merchant/discounts')
      expect(page).to have_content('Five on Five')
      expect(page).to have_content('Your discount has been created.')
    end

    it 'Can\'t create new discount with missing input fields, show flash messages and redirect to #new' do

      visit '/merchant/discounts'
      click_link 'New Discount'
      expect(current_path).to eq('/merchant/discounts/new')

      fill_in 'Name', with: 'Five on Five'
      # fill_in 'Item Minimum', with: 5
      fill_in 'Percent', with: 5
      click_on 'Create Discount'

      expect(current_path).to eq('/merchant/discounts/new')
      expect(page).to have_content('Item minimum can\'t be blank')
    end
  end
end
