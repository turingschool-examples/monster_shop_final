require 'rails_helper'

RSpec.describe 'Merchant Deletess Discounts' do
  describe 'As a Merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @discount = @merchant_1.discounts.create(name: '7 Percent', percentage: 0.07, limit: 14)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'A merchant can delete their own Discount' do
      visit '/merchant/discounts'

      within "#discount-#{@discount.id}" do
        expect(page).to have_button("Delete")
        click_button ("Delete")
      end

      expect(current_path).to eq('/merchant/discounts')
    end
  end
end
