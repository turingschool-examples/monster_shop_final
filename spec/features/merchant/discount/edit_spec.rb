require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Merchant Discount Edit' do
  describe 'As a Merchant employee' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @discount_1 = Discount.create!(quantity: 5, percentage: 20, merchant_id: @merchant_1.id)
      @discount_2 = Discount.create!(quantity: 10, percentage: 25, merchant_id: @merchant_1.id)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'When I click the edit link I am taken to a form to edit that discount' do
      visit '/merchant/discounts'

      within "#discount-#{@discount_1.id}" do
        click_link 'Edit'
      end
      
      expect(current_path).to eq("/merchant/discounts/#{@discount_1.id}/edit")
    end

    it 'When I fill out the edit form completely, I am returned to the discount index and see the updated discount' do
      visit "/merchant/discounts/#{@discount_1.id}/edit"

      fill_in 'Quantity', with: 10
      fill_in 'Percentage', with: 30
      click_button 'Update Discount'

      expect(current_path).to eq("/merchant/discounts")

      within "#discount-#{@discount_1.id}" do
        expect(page).to have_content("30 percent off 10 items")
        expect(page).to_not have_content("20 percent off 5 items")
      end
    end

    it 'When I fill out the edit form incompletely, I see a message and I am returned to the discount edit form' do
      @discount_1 = Discount.create!(quantity: 5, percentage: 20, merchant_id: @merchant_1.id)
      
      visit "/merchant/discounts/#{@discount_1.id}/edit"

      fill_in 'Quantity', with: ""
      fill_in 'Percentage', with: ""
      click_button 'Update Discount'

      expect(page).to have_content("percentage: [\"Percentage must be 1 - 99\"]")
      expect(page).to have_content("[\"is not a number\"]")
      expect(page).to have_content('Edit Discount')
    end
  end
end