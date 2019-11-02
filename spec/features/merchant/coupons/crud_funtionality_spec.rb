# frozen_string_literal: true

require 'rails_helper'

describe 'As a Merchant' do
  describe 'I have full CRUD functionality over my coupons' do
    before :each do
      merchant = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80_218)
      @coupon = merchant.coupons.create!(name: 'New User Discount', discount: 10)

      user = merchant.users.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80_218, email: 'meganexample.com', password: 'securepassword')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit merchant_coupons_path
    end

    it 'I can create a coupon' do
      click_link 'Create New Coupon'

      expect(current_path).to eq(new_merchant_coupon_path)

      fill_in 'Name', with: 'Bulk Discount'
      fill_in 'Discount', with: 10
      click_button 'Create Coupon'

      expect(current_path).to eq(merchant_coupons_path)

      coupon = Coupon.last

      within "#coupon-#{coupon.id}" do
        expect(page).to have_content('Coupon Name: Bulk Discount')
        expect(page).to have_content('Discount: 10%')
      end
    end

    it 'I can edit a coupon' do
      within "#coupon-#{@coupon.id}" do
        click_link 'Edit Coupon'
      end

      expect(current_path).to eq(edit_merchant_coupon_path(@coupon))

      expect(find_field(:name).value).to eq(@coupon.name)
      expect(find_field(:discount).value).to eq(@coupon.discount.to_s)

      fill_in 'name', with: 'New Discount'
      fill_in 'discount', with: 15
      click_button 'Update Coupon'

      expect(current_path).to eq(merchant_coupons_path)

      @coupon.reload
      visit merchant_coupons_path

      within "#coupon-#{@coupon.id}" do
        expect(page).to have_content('Coupon Name: New Discount')
        expect(page).to have_content('Discount: 15%')
      end
    end

    it 'I can enable/disable a coupon' do
    end

    it 'I cannot delete a coupon that has been used' do
    end

    it 'I can have a maximum of 5 coupons' do
    end
  end
end
