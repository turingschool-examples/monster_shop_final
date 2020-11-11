require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Order Show Page' do
  describe 'As a Registered User' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @sal = Merchant.create!(name: 'Sals Salamanders', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 2 )
      @user = User.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan_1@example.com', password: 'securepassword')

      visit '/login'
      fill_in 'Email', with: @user.email  
      fill_in 'Password', with: @user.password
      click_button 'Log In'

      visit item_path(@ogre)
      click_button 'Add to Cart'
      visit '/cart'
      within "#item-#{@ogre.id}" do
        click_button('More of This!')
      end
      click_button 'Check Out'
      @order_1 = Order.last
      @order_item_1 = @order_1.order_items
      

      visit item_path(@giant)
      click_button 'Add to Cart'

      visit item_path(@ogre)
      click_button 'Add to Cart'

      visit '/cart'
      within "#item-#{@giant.id}" do
        click_button('More of This!')
      end
      within "#item-#{@ogre.id}" do
        click_button('More of This!')
      end
      click_button 'Check Out'
      @order_2 = Order.last
      @order_item_2 = @order_2.order_items

      visit '/profile/orders'
    end

    it 'I can link from my orders to an order show page' do
      visit '/profile/orders'

      click_link @order_1.id

      expect(current_path).to eq("/profile/orders/#{@order_1.id}")
    end

    it 'I see order information on the show page' do
      visit "/profile/orders/#{@order_2.id}"

      expect(page).to have_content(@order_2.id)
      expect(page).to have_content("Created On: #{@order_2.created_at}")
      expect(page).to have_content("Updated On: #{@order_2.updated_at}")
      expect(page).to have_content("Status: #{@order_2.status}")
      expect(page).to have_content("#{@order_2.count_of_items} items")
      expect(page).to have_content("Total: #{number_to_currency(@order_2.grand_total)}")

      expect(page).to have_link(@ogre.name)
      expect(page).to have_content(@ogre.description)
      expect(page).to have_content('Quantity: 2')
      expect(page).to have_content(@ogre.price)
      expect(page).to have_content('Subtotal: $40.50')

      expect(page).to have_link(@giant.name)
      expect(page).to have_content(@giant.description)
      expect(page).to have_content('Quantity: 2')
      expect(page).to have_content(@giant.price)
      expect(page).to have_content('Subtotal: $100.00')
    end

    it 'I see a link to cancel an order, only on a pending order show page' do
      order_3 = @user.orders.create!(status: "packaged")
      order_4 = @user.orders.create!(status: "pending")
      visit "/profile/orders/#{order_3.id}"

      expect(page).to_not have_button('Cancel Order')

      visit "/profile/orders/#{order_4.id}"

      expect(page).to have_button('Cancel Order')
    end

    it 'I can cancel an order to return its contents to the items inventory' do
      visit "/profile/orders/#{@order_2.id}"

      click_button 'Cancel Order'

      expect(current_path).to eq("/profile/orders/#{@order_2.id}")
      expect(page).to have_content("Status: cancelled")

      @giant.reload
      @ogre.reload

      expect(@order_1.order_items.first.fulfilled?).to eq(false)
      expect(@order_2.order_items.first.fulfilled?).to eq(false)
      expect(@giant.inventory).to eq(5)
      expect(@ogre.inventory).to eq(7)
    end

    it 'I can see the subtotal including the discount, for item in my order' do
      discount_1 = Discount.create!(quantity: 2, amount: 5, merchant_id: @megan.id)
      discount_2 = Discount.create!(quantity: 3, amount: 10, merchant_id: @megan.id)
      visit item_path(@ogre)
      click_button 'Add to Cart'

      visit '/cart'
      within "#item-#{@ogre.id}" do
        click_button('More of This!')
        click_button('More of This!')
        expect(page).to have_content("Discount: #{discount_2.amount}% off!")
        expect(page).to have_content('Subtotal: $54.68')
      end

      click_button 'Check Out'

      order = Order.last
      visit "/profile/orders/#{order.id}"

      expect(page).to have_link(@ogre.name)
      expect(page).to have_content("Quantity: 3")
      expect(page).to have_content("Price: $18.23")
      expect(page).to have_content("Total: $54.68")
    end

    it 'if I add multiple items to my order it will calculate the total cost' do
      discount_1 = Discount.create!(quantity: 2, amount: 5, merchant_id: @megan.id)
      discount_2 = Discount.create!(quantity: 3, amount: 10, merchant_id: @megan.id)
      visit item_path(@ogre)
      click_button 'Add to Cart'

      visit item_path(@giant)
      click_button 'Add to Cart'

      visit '/cart'
      within "#item-#{@ogre.id}" do
        click_button('More of This!')
        click_button('More of This!')
      end

      click_button 'Check Out'

      order = Order.last
      visit "/profile/orders/#{order.id}"

      expect(page).to have_content("Total: $104.68")
      expect(page).to have_link(@ogre.name)
      expect(page).to have_content("Quantity: 3")
      expect(page).to have_content("Price: $18.23")
    end
  end
end
