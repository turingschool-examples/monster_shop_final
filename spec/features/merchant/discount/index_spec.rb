require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Merchant Discount Index' do
  describe 'As a Merchant employee' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @discount_1 = Discount.create!(quantity: 5, percentage: 20, merchant_id: @merchant_1.id)
      @discount_2 = Discount.create!(quantity: 10, percentage: 25, merchant_id: @merchant_1.id)
      @discount_3 = Discount.create!(quantity: 15, percentage: 7, merchant_id: @merchant_2.id)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'I can link to my merchant discounts index from the dashboard' do
      visit '/merchant/'

      click_link 'My Discounts'

      expect(current_path).to eq('/merchant/discounts')
    end

    it 'I can click a link to my merchant discounts index and see all my current discounts' do
      visit '/merchant'
    
      click_link 'My Discounts'
      
      within "#discount-#{@discount_1.id}" do
        expect(page).to have_content("#{@discount_1.percentage} percent off #{@discount_1.quantity} items")
      end
      
      within "#discount-#{@discount_2.id}" do
        expect(page).to have_content("#{@discount_2.percentage} percent off #{@discount_2.quantity} items")
      end

      expect(page).to_not have_content(@discount_3.quantity)
      expect(page).to_not have_content(@discount_3.percentage)
    end

    it 'Next to each discount is a link to edit and delete the discount' do
      visit '/merchant/discounts'

      within "#discount-#{@discount_1.id}" do
        expect(page).to have_link('Edit')
        expect(page).to have_link('Delete')
      end
      
      within "#discount-#{@discount_2.id}" do
        expect(page).to have_link('Edit')
        expect(page).to have_link('Delete')
      end
    end

    it 'On the discount index page there is a link to create a new discount' do
      visit '/merchant/discounts'
      expect(page).to have_link('New Discount')
    end
  end
end