require 'rails_helper'

RSpec.describe 'Discount Cart Show Page' do
  describe 'As a Merchant Employee or User or Visitor' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @metroid_shop = Merchant.create(name: "Hope's Metroid Shop", address: '125 XR42 St.', city: 'Denver', state: 'CO', zip: 80210)

      @orge = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 6 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 20 )
      @flamingo = @brian.items.create!(name: 'Flamingo', description: "I'm a Flamingo!", price: 500, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 12 )
      @scorpian = @brian.items.create!(name: 'Scorpian', description: "I'm a Scorpian!", price: 25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 15 )
      @rock = @metroid_shop.items.create!(name: 'Rocks', description: "I'm a Rock!", price: 35, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 10 )

      @megan_discount_1 = @megan.discounts.create!(description: "Buy 5 items, get 5% off", quantity: 5, percent: 5)
      @megan_discount_2 = @megan.discounts.create!(description: "Buy 10 items, get 25% off", quantity: 10, percent: 25)

      @brian_discount_3 = @brian.discounts.create!(description: "Buy 10 items, get 45% off", quantity: 10, percent: 45)
      @brian_discount_4 = @brian.discounts.create!(description: "Buy 5 items, get 10% off", quantity: 5, percent: 10)
      @brian_discount_5 = @brian.discounts.create!(description: "Buy 6 items, get 30% off", quantity: 6, percent: 30)

      # allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

    end

    it 'can have a change of price when the discount is met' do
      4.times do
        visit "/items/#{@giant.id}"
        click_button 'Add to Cart'
      end

      visit "/items/#{@orge.id}"
      click_button 'Add to Cart'

      visit "/items/#{@hippo.id}"
      click_button 'Add to Cart'

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

      expect(page).to have_content('Total: $307.50')
      expect(page).to_not have_content('Total: $320.00')
      expect(page).to have_content('Wahoo! You qualify for a bulk discount!')
      expect(page).to have_content('Total Savings: $12.50')
    end

    it 'can remove a discount if the number of items changes to be too few' do
      5.times do
        visit "/items/#{@giant.id}"
        click_button 'Add to Cart'
      end

      visit "/items/#{@orge.id}"
      click_button 'Add to Cart'

      visit "/items/#{@hippo.id}"
      click_button 'Add to Cart'

      visit '/cart'

      within "#item-#{@giant.id}" do
        expect(page).to have_content('Quantity: 5')
      end

      within "#item-#{@orge.id}" do
        expect(page).to have_content('Quantity: 1')
      end

      within "#item-#{@hippo.id}" do
        expect(page).to have_content('Quantity: 1')
      end

      expect(page).to have_content('Total: $307.50')

      within "#item-#{@giant.id}" do
        click_button('Less of This!')
      end

      expect(page).to have_content('Total: $270.00')
      expect(page).to have_content('Buy 5 items, get 5% off')
      within "#item-#{@giant.id}" do
        expect(page).to have_content('Quantity: 4')
      end
    end

    it 'can be shown that there are no available discounts offered by the merchant' do
      2.times do
        visit "/items/#{@rock.id}"
        click_button 'Add to Cart'
      end

      visit '/cart'

      within "#item-#{@rock.id}" do
        expect(page).to have_content('Quantity: 2')
      end

      expect(page).to have_content('Total: $70.00')
      expect(page).to have_content('There are no discounts available at this moment')
    end

    it 'can only have one (the biggest) discount apply to items, if more than one discount applies to the items in the cart' do
      6.times do
        visit "/items/#{@hippo.id}"
        click_button 'Add to Cart'
      end

      visit '/cart'

      within "#item-#{@hippo.id}" do
        expect(page).to have_content('Quantity: 6')
      end

      expect(page).to have_content('Total: $210.00')
      expect(page).to_not have_content('Total: $225.00')
      expect(page).to have_content('Wahoo! You qualify for a bulk discount!')
      expect(page).to have_content('Total Savings: $90.00')
    end
  end
end
