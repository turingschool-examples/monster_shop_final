# frozen_string_literal: true

require 'rails_helper'

describe 'As a Merchant' do
  describe 'I have full CRUD functionality over my coupons' do
    before :each do
      merchant = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80_218)
      user = merchant.users.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80_218, email: 'meganexample.com', password: 'securepassword')
      @coupon = merchant.coupons.create!(name: 'New User Discount', discount: 10)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      visit merchant_coupons_path
    end

    it 'I can create a coupon' do
      save_and_open_page
      click_link 'Create New Coupon'

      expect(current_path).to eq(merchant_coupons_new_path)

      fill_in 'Name', with: 'Bulk Discount'
      fill_in 'Discount', with: '10%'
      click_button 'Create Coupon'

      expect(current_path).to eq(merchant_coupons_path)

      coupon = Coupon.last

      within "#coupon-#{coupon.id}" do
        expect(page).to have_content('Coupon Name: Bulk Discount')
        expect(page).to have_content('Discount: 10%')
      end
    end

    it 'I can edit a coupon' do
    end

    it 'I can enable/disable a coupon' do
    end

    it 'I cannot delete a coupon that has been used' do
    end

    it 'I can have a maximum of 5 coupons' do
    end
  end
end
