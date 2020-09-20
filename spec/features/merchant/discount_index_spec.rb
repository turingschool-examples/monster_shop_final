require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Merchant Discounts Index' do
  describe 'As a Merchant employee' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Morgans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Morgan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'morgan@example.com', password: 'securepassword')
      @ogre = @merchant_1.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @nessie = @merchant_1.items.create!(name: 'Nessie', description: "I'm a Loch Monster!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @merchant_1.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: false, inventory: 3 )
      @hippo = @merchant_2.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 1 )
      @discount_1 = @merchant_1.discounts.create!(percent: 20, min_items: 5, active: true)
      @discount_2 = @merchant_1.discounts.create!(percent: 50, min_items: 10)
      @discount_3 = @merchant_1.discounts.create!(percent: 75, min_items: 20, active: true)
      @order_1 = @m_user.orders.create!(status: "pending")
      @order_2 = @m_user.orders.create!(status: "pending")
      @order_3 = @m_user.orders.create!(status: "pending")
      @order_item_1 = @order_1.order_items.create!(item: @hippo, price: @hippo.price, quantity: 2, fulfilled: false)
      @order_item_2 = @order_2.order_items.create!(item: @hippo, price: @hippo.price, quantity: 2, fulfilled: true)
      @order_item_3 = @order_2.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: false)
      @order_item_4 = @order_3.order_items.create!(item: @giant, price: @giant.price, quantity: 4, fulfilled: false)
      @order_1.order_discounts.create!(discount: @discount_1)
      @order_2.order_discounts.create!(discount: @discount_2)
      @order_3.order_discounts.create!(discount: @discount_3)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
      visit '/merchant/discounts'
    end

    it 'I see my discounts, including inactive discounts' do
      within "#discount-#{@discount_1.id}" do
        expect(page).to have_content(@discount_1.percent)
        expect(page).to have_content(@discount_1.min_items)
        expect(page).to have_content("Active")
        expect(page).to have_button('Inactivate')
        expect(page).to have_button('Update Discount')
        expect(page).to have_button('Delete')
      end

      within "#discount-#{@discount_2.id}" do
        expect(page).to have_content(@discount_2.percent)
        expect(page).to have_content(@discount_2.min_items)
        expect(page).to have_content("Inactive")
        expect(page).to have_button('Activate')
        expect(page).to have_button('Update Discount')
        expect(page).to have_button('Delete')
      end
    end

    it 'I can deactivate a discount' do

      within "#discount-#{@discount_1.id}" do
        click_button 'Inactivate'
      end

      expect(current_path).to eq('/merchant/discounts')
      expect(page).to have_content("#{@discount_1.percent}% Off #{@discount_1.min_items} Items or More is no longer active")
    end

    it 'I can activate a discount' do

      within "#discount-#{@discount_2.id}" do
        click_button 'Activate'
      end

      expect(current_path).to eq('/merchant/discounts')
      expect(page).to have_content("#{@discount_2.percent}% Off #{@discount_2.min_items} Items or More is now active")
    end

    it 'I can delete discounts' do

      within "#discount-#{@discount_3.id}" do
        click_button 'Delete'
      end

      expect(current_path).to eq('/merchant/discounts')
    end
  end
end
