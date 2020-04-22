require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Merchant Discount New' do
  describe 'As a Merchant employee' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'When I click the new discount link I am taken to a form to create a new discount' do
      visit '/merchant/discounts'

      click_link 'New Discount'
      
      expect(current_path).to eq('/merchant/discounts/new')
    end

    it 'When I completely fill out a new discount form I am returned to the dicount index where I see the new discount' do
      visit '/merchant/discounts/new'
    
      fill_in 'Quantity', with: 20
      fill_in 'Percentage', with: 5
      click_button 'Create Discount'

      new_discount = Discount.last
      
      expect(current_path).to eq('/merchant/discounts')
      
      within "#discount-#{new_discount.id}" do
        expect(page).to have_content("#{new_discount.percentage} percent off #{new_discount.quantity} items")
      end
    end

    it 'When I incorrectly fill out a new discount I see a flash message and get returned to the form' do
      visit '/merchant/discounts/new'
    
      fill_in 'Quantity', with: ''
      fill_in 'Percentage', with: ''
      click_button 'Create Discount'

      expect(page).to have_content("percentage: [\"Percentage must be 1 - 99\"]")
      expect(page).to have_content("[\"is not a number\"]")
      expect(page).to have_content('New Discount')
    end
  end
end