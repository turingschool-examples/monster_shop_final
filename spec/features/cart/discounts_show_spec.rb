
require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Cart Show Page' do
  describe 'As a Visitor' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @m_user = User.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', merchant_id: @megan.id)
      
      visit '/login'
      fill_in 'Email', with: @m_user.email  
      fill_in 'Password', with: @m_user.password
      click_button 'Log In'

      visit '/merchant/discounts'
      click_link 'New Bulk Discount'
      fill_in :amount, with: '5'
      fill_in :quantity, with: '3'
      click_on 'Submit'

      @discount_1 = Discount.last
    end

    it 'a discount will be applied if I have the correct number of items in my cart for a discount' do
      visit item_path(@ogre)
      click_button 'Add to Cart'

      visit '/cart'

      within "#item-#{@ogre.id}" do
        click_button('More of This!')
        click_button('More of This!')
        expect(page).to have_content("Discount: #{@discount_1.amount}% off!")
        expect(page).to have_content('Subtotal: $57.00')
      end
      expect(page).to have_content('Total: $57.00')
    end

    it 'a discount will only be applied to the item for which the quantity meets the discount requirements' do

      visit item_path(@ogre)
      click_button 'Add to Cart'

      visit item_path(@giant)
      click_button 'Add to Cart'

      visit '/cart'
      
      within "#item-#{@ogre.id}" do
        click_button('More of This!')
        click_button('More of This!')
        expect(page).to have_content("Discount: #{@discount_1.amount}% off!")
        expect(page).to have_content('Subtotal: $57.00')
      end
      
      within "#item-#{@giant.id}" do
        expect(page).to have_content("Discount: 0% off!")
        expect(page).to have_content('Subtotal: $50.00')
      end

      expect(page).to have_content('Total: $107.00')
    end

    it 'a discount is only applied to items sold by the merchant who offers the discount' do
      visit item_path(@ogre)
      click_button 'Add to Cart'

      visit item_path(@hippo)
      click_button 'Add to Cart'

      visit '/cart'
      
      within "#item-#{@ogre.id}" do
        click_button('More of This!')
        click_button('More of This!')
        expect(page).to have_content("Discount: #{@discount_1.amount}% off!")
        expect(page).to have_content('Subtotal: $57.00')
      end
      
      within "#item-#{@hippo.id}" do
        click_button('More of This!')
        click_button('More of This!')
        expect(page).to have_content("Discount: 0% off!")
        expect(page).to have_content('Subtotal: $150.00')
      end

      expect(page).to have_content('Total: $207.00')
    end

    it 'a discount is only applied to items for that merchant offers' do
      discount_2 = Discount.create!(quantity: 2, amount: 2, merchant_id: @megan.id)
      discount_3 = Discount.create!(quantity: 3, amount: 5, merchant_id: @megan.id)

      visit item_path(@ogre)
      click_button 'Add to Cart'

      visit item_path(@hippo)
      click_button 'Add to Cart'

      visit '/cart'
      
      within "#item-#{@ogre.id}" do
        click_button('More of This!')
        click_button('More of This!')
        expect(page).to have_content("Discount: #{discount_3.amount}% off!")
        expect(page).to have_content('Subtotal: $57.00')
      end
      
      within "#item-#{@hippo.id}" do
        click_button('More of This!')
        click_button('More of This!')
        expect(page).to have_content("Discount: 0% off!")
        expect(page).to have_content('Subtotal: $150.00')
      end

      expect(page).to have_content('Total: $207.00')
    end

    it 'a merchant has a discount, but you dont have any of their items in your cart' do
      visit item_path(@hippo)
      click_button 'Add to Cart'

      visit '/cart' 
      
      within "#item-#{@hippo.id}" do
        click_button('More of This!')
        click_button('More of This!')
        expect(page).to have_content("Discount: 0% off!")
        expect(page).to have_content('Subtotal: $150.00')
      end

      expect(page).to have_content('Total: $150.00')
    end

    it 'the order_item subtotal is updated in the db' do
      discount_1 = Discount.create!(quantity: 2, amount: 2, merchant_id: @megan.id)
      discount_2 = Discount.create!(quantity: 3, amount: 5, merchant_id: @megan.id)

      visit item_path(@ogre)
      click_button 'Add to Cart'

      visit item_path(@hippo)
      click_button 'Add to Cart'

      visit '/cart'
      
      within "#item-#{@ogre.id}" do
        click_button('More of This!')
        click_button('More of This!')
        expect(page).to have_content("Discount: #{discount_2.amount}% off!")
        expect(page).to have_content('Subtotal: $57.00')
      end
      
      within "#item-#{@hippo.id}" do
        click_button('More of This!')
        click_button('More of This!')
        expect(page).to have_content("Discount: 0% off!")
        expect(page).to have_content('Subtotal: $150.00')
      end

      click_button 'Check Out'

      # Check db and find item_order subtotal for each item_order
      order = Order.last
      expect(order.order_items.where(item_id: @ogre.id).first.subtotal).to eq(57)
      expect(order.order_items.where(item_id: @hippo.id).first.subtotal).to eq(150)
    end
  end
end
