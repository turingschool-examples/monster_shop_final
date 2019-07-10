require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Create Order' do
  describe 'As a Visitor' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
    end

    it 'I can click a link to get to an order creation page' do
      visit item_path(@ogre)
      click_button 'Add to Cart'
      visit item_path(@hippo)
      click_button 'Add to Cart'
      visit item_path(@hippo)
      click_button 'Add to Cart'

      visit '/cart'

      click_button 'Check Out'

      expect(current_path).to eq(new_order_path)
      expect(page).to have_content("Total: #{number_to_currency((@ogre.price * 1) + (@hippo.price * 2))}")

      within "#item-#{@ogre.id}" do
        expect(page).to have_link(@ogre.name)
        expect(page).to have_content("Price: #{number_to_currency(@ogre.price)}")
        expect(page).to have_content("Quantity: 1")
        expect(page).to have_content("Subtotal: #{number_to_currency(@ogre.price * 1)}")
        expect(page).to have_content("Sold by: #{@megan.name}")
        expect(page).to have_link(@megan.name)
      end

      within "#item-#{@hippo.id}" do
        expect(page).to have_link(@hippo.name)
        expect(page).to have_content("Price: #{number_to_currency(@hippo.price)}")
        expect(page).to have_content("Quantity: 2")
        expect(page).to have_content("Subtotal: #{number_to_currency(@hippo.price * 2)}")
        expect(page).to have_content("Sold by: #{@brian.name}")
        expect(page).to have_link(@brian.name)
      end
    end

    it 'I can create an order from the new order page' do
      visit item_path(@ogre)
      click_button 'Add to Cart'
      visit item_path(@hippo)
      click_button 'Add to Cart'
      visit item_path(@hippo)
      click_button 'Add to Cart'

      name = 'Megan M'
      address = '123 Main St'
      city = 'Denver'
      state = 'CO'
      zip = '80218'

      visit new_order_path

      fill_in 'Name', with: name
      fill_in 'Address', with: address
      fill_in 'City', with: city
      fill_in 'State', with: state
      fill_in 'Zip', with: zip
      click_button 'Create Order'

      new_order = Order.last

      expect(current_path).to eq(order_path(new_order))
      expect(page).to have_content('Cart: 0')

      within '.shipping-address' do
        expect(page).to have_content(name)
        expect(page).to have_content("#{address}\n#{city} #{state} #{zip}")
      end
      expect(page).to have_content("Order Created: #{new_order.created_at}")
      expect(page).to have_content("Total: #{number_to_currency((@ogre.price * 1) + (@hippo.price * 2))}")
      within "#item-#{@ogre.id}" do
        expect(page).to have_link(@ogre.name)
        expect(page).to have_content("Price: #{number_to_currency(@ogre.price)}")
        expect(page).to have_content("Quantity: 1")
        expect(page).to have_content("Subtotal: #{number_to_currency(@ogre.price * 1)}")
        expect(page).to have_content("Sold by: #{@megan.name}")
        expect(page).to have_link(@megan.name)
      end

      within "#item-#{@hippo.id}" do
        expect(page).to have_link(@hippo.name)
        expect(page).to have_content("Price: #{number_to_currency(@hippo.price)}")
        expect(page).to have_content("Quantity: 2")
        expect(page).to have_content("Subtotal: #{number_to_currency(@hippo.price * 2)}")
        expect(page).to have_content("Sold by: #{@brian.name}")
        expect(page).to have_link(@brian.name)
      end
    end

    it 'I must include all shipping address fields to create an order' do
      visit item_path(@hippo)
      click_button 'Add to Cart'

      name = 'Megan M'
      address = '123 Main St'
      city = 'Denver'
      state = 'CO'
      zip = '80218'

      visit new_order_path

      fill_in 'Name', with: name
      fill_in 'Address', with: address
      click_button 'Create Order'

      expect(page).to have_content("Please complete address form to create an order.")
    end
  end
end
