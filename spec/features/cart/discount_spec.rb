require 'rails_helper'

RSpec.describe 'Discount Cart Show Page' do
  describe 'As a Merchant Employee or User or Visitor' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)

      @orge = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 6 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )

      @megan_discount_1 = @megan.discounts.create!(description: "Buy 5 items, get 5% off", quantity: 5, percent: 5)
      @megan_discount_2 = @megan.discounts.create!(description: "Buy 10 items, get 25% off", quantity: 10, percent: 25)

      @brian_discount_3 = @brian.discounts.create!(description: "Buy 10 items, get 45% off", quantity: 10, percent: 45)
      @brian_discount_4 = @brian.discounts.create!(description: "Buy 5 items, get 10% off", quantity: 5, percent: 10)
      @brian_discount_5 = @brian.discounts.create!(description: "Buy 6 items, get 30% off", quantity: 6, percent: 30)
      # allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit "/items/#{@giant.id}"
      click_button 'Add to Cart'
      visit "/items/#{@giant.id}"
      click_button 'Add to Cart'
      visit "/items/#{@giant.id}"
      click_button 'Add to Cart'
      visit "/items/#{@giant.id}"
      click_button 'Add to Cart'

      visit "/items/#{@orge.id}"
      click_button 'Add to Cart'

      visit "/items/#{@hippo.id}"
      click_button 'Add to Cart'
    end

    it 'can have a change of price when the discount is met' do
      visit '/cart'

      within "#item-#{@giant.id}" do
        expect(page).to have_content('Quantity: 4')
      end

      within "#item-#{@orge.id}" do
        expect(page).to have_content('Quantity: 1')
      end

      within "#item-#{@hippo.id}" do
        expect(page).to have_content('Quantity: 1')
      end

      expect(page).to have_content('Total: $270.00')

      within "#item-#{@giant.id}" do
        click_button('More of This!')
      end

      expect(page).to have_content('Total: $277.50')
      expect(page).to_not have_content('Total: $290.00')
      expect(page).to have_content('Total Savings: $12.50')
    end
  end
end
