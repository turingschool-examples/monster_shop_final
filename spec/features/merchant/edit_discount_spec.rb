require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Update Discount Page' do
  describe 'As a Visitor' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Morgans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @discount_1 = @merchant_1.discounts.create!(name: "20% Off", active: true)
      @m_user = @merchant_1.users.create(name: 'Morgan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'morgan@example.com', password: 'securepassword')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'I can click a link to get to an discount edit page' do
      visit "/merchant/discounts"

      click_link 'Update Discount'

      expect(current_path).to eq("/merchant/discounts/#{@discount_1.id}/edit")
    end

    it 'I can edit the discounts information' do
      name = '90% off on 20 or more items'

      visit "merchant/discounts/#{@discount_1.id}/edit"

      fill_in 'Name', with: name

      click_button 'Update Discount'

      expect(current_path).to eq("/merchant/discounts")
      expect(page).to have_content("Active")
    end

    it 'I can not edit the discount with an incomplete form' do
      name = ''

      visit "merchant/discounts/#{@discount_1.id}/edit"

      fill_in 'Name', with: name
      click_button 'Update Discount'

      expect(page).to have_content("name: [\"can't be blank\"]")
    end
  end
end
