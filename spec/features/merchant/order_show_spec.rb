require 'rails_helper'

RSpec.describe 'Merchant Order Show Page' do
  describe 'As a Merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @ogre = @merchant_1.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @merchant_1.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @merchant_2.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 1 )
      @order_1 = @m_user.orders.create!(status: "pending")
      @order_2 = @m_user.orders.create!(status: "pending")
      @order_item_1 = @order_1.order_items.create!(item: @hippo, price: @hippo.price, quantity: 2, fulfilled: false)
      @order_item_2 = @order_2.order_items.create!(item: @hippo, price: @hippo.price, quantity: 2, fulfilled: true)
      @order_item_3 = @order_2.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: false)
      @order_item_4 = @order_2.order_items.create!(item: @giant, price: @giant.price, quantity: 2, fulfilled: false)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'I can see order information with only my order items' do
      visit "/merchant/orders/#{@order_2.id}"

      expect(page).to have_content(@m_user.name)
      expect(page).to have_content(@m_user.address)
      expect(page).to have_content(@m_user.city)
      expect(page).to have_content(@m_user.state)
      expect(page).to have_content(@m_user.zip)

      within "#order-item-#{@order_item_3.id}" do
        expect(page).to have_link(@order_item_3.item.name)
        expect(page).to have_content(@order_item_3.price)
        expect(page).to have_content(@order_item_3.quantity)
      end

      expect(page).to_not have_css("#order-item-#{@order_item_2.id}")
    end

    it 'I can fulfill order items' do
      visit "/merchant/orders/#{@order_2.id}"

      expect(page).to have_content("Status: pending")

      within "#order-item-#{@order_item_3.id}" do
        expect(page).to_not have_content('Fulfilled')
        click_link('Fulfill')
      end

      expect(current_path).to eq("/merchant/orders/#{@order_2.id}")

      @m_user.reload
      @ogre.reload

      visit "/merchant/orders/#{@order_2.id}"
      expect(page).to have_content("Status: pending")

      within "#order-item-#{@order_item_3.id}" do
        expect(page).to have_content('Fulfilled')
        expect(page).to_not have_link('Fulfill')
      end

      expect(@ogre.inventory).to eq(3)
    end

    it 'I can not fulfill order items where there is not enough inventory' do
      @order_item_3.update(quantity: 8)

      visit "/merchant/orders/#{@order_2.id}"

      within "#order-item-#{@order_item_3.id}" do
        expect(page).to_not have_link('Fulfill')
        expect(page).to have_content('Insufficient Inventory')
      end
    end

    it 'When all order items are fulfilled, order is packaged' do
      visit "/merchant/orders/#{@order_2.id}"

      within "#order-item-#{@order_item_3.id}" do
        click_link('Fulfill')
      end

      expect(page).to have_content("Status: pending")

      within "#order-item-#{@order_item_4.id}" do
        click_link('Fulfill')
      end

      expect(page).to have_content("Status: packaged")
    end
  end
end
