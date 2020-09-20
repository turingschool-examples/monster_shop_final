require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Update Discount Page' do
  describe 'As a Visitor' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Morgans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @discount_1 = @merchant_1.discounts.create!(percent: 20, min_items: 5, active: true)
      @m_user = @merchant_1.users.create(name: 'Morgan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'morgan@example.com', password: 'securepassword')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'I can click a link to get to an discount edit page' do
      visit "/merchant/discounts"

      click_button 'Update Discount'

      expect(current_path).to eq("/merchant/discounts/#{@discount_1.id}/edit")
    end

    it 'I can edit the discounts information' do
      percent = 110
      min_items = 4

      visit "merchant/discounts/#{@discount_1.id}/edit"

      fill_in 'Percent', with: percent
      fill_in 'Min items', with: min_items

      click_button 'Update Discount'

      expect(current_path).to eq("/merchant/discounts")
      expect(page).to have_content(percent)
      expect(page).to have_content(min_items)
      expect(page).to have_content("Active")
    end

    it 'I can not edit the discount with an incomplete form' do
      percent = ''
      min_items = 4

      visit "merchant/discounts/#{@discount_1.id}/edit"

      fill_in 'Percent', with: percent
      fill_in 'Min items', with: min_items
      click_button 'Update Discount'

      expect(page).to have_content("percent: [\"can't be blank\"]")
    end
  end
end
