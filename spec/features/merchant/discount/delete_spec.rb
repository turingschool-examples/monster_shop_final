require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Merchant Discount Edit' do
  describe 'As a Merchant employee' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @discount_1 = Discount.create!(quantity: 7, percentage: 13, merchant_id: @merchant_1.id)
      @discount_2 = Discount.create!(quantity: 10, percentage: 25, merchant_id: @merchant_1.id)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'When I click the delete link the discount is deleted and I am taken back to the index where I no longer see that discount' do
      
      visit '/merchant/discounts'

      within "#discount-#{@discount_1.id}" do
        click_link 'Delete'
      end
      expect(current_path).to eq('/merchant/discounts')
      
      @merchant_1.reload
      visit '/merchant/discounts'
      
      expect(page).to_not have_content('7')
      expect(page).to_not have_content('13')
    end
  end
end