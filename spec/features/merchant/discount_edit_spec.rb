require 'rails_helper'

RSpec.describe 'Merchant Discount Edit' do
  describe 'As a Merchant employee' do
    before :each do
      @megan_shop = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @employee = User.create!(name: 'Gaby Mendez', address: '1422 NE 20th Ave.', city: 'Gainesville', state: 'FL', zip: 32609, role: 1, email: 'employee@hotmail.com', password: 'employee', merchant_id: @megan_shop.id)

      @twenty_ten = Discount.create!(name: 'Twenty on Ten', item_minimum: 10, percent: 20, merchant_id: @megan_shop.id)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@employee)
    end

    it 'I see that on a Discount\'s show page, there is a link to edit the discount details' do

      visit "/merchant/discounts/#{@twenty_ten.id}"
      click_link 'Edit'

      expect(current_path).to eq("/merchant/discounts/#{@twenty_ten.id}/edit")

      find_field('Name', with: 'Twenty on Ten')
      find_field('Item minimum', with: '10')
      find_field('Percent', with: '20')

      fill_in 'Name', with: 'Twenty on Twenty'
      fill_in 'Item minimum', with: 20
      click_on 'Update Discount'

      expect(current_path).to eq("/merchant/discounts/#{@twenty_ten.id}")

      expect(page).to have_content('Twenty on Twenty')
      expect(page).to have_content('20')
      expect(page).to have_content('20')
    end

    it 'Can\'t update Discount if any fields are left blank' do

      visit "/merchant/discounts/#{@twenty_ten.id}/edit"

      fill_in 'Name', with: nil
      click_on 'Update Discount'

      expect(current_path).to eq("/merchant/discounts/#{@twenty_ten.id}/edit")
      expect(page).to have_content("Name can't be blank")
    end
  end
end
