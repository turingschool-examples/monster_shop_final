require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Merchant Discount Edit' do
  describe 'As a Merchant employee' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @ogre = @merchant_1.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @nessie = @merchant_1.items.create!(name: 'Nessie', description: "I'm a Loch Monster!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @merchant_1.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: false, inventory: 3 )
      @hippo = @merchant_2.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 1 )
      @order_1 = @m_user.orders.create!(status: "pending")
      @order_2 = @m_user.orders.create!(status: "pending")
      @order_3 = @m_user.orders.create!(status: "pending")
      @order_item_1 = @order_1.order_items.create!(item: @hippo, price: @hippo.price, quantity: 2, fulfilled: false)
      @order_item_2 = @order_2.order_items.create!(item: @hippo, price: @hippo.price, quantity: 2, fulfilled: true)
      @order_item_3 = @order_2.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: false)
      @order_item_4 = @order_3.order_items.create!(item: @giant, price: @giant.price, quantity: 4, fulfilled: false)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'When I click the edit link I am taken to a form to edit that discount' do
      discount_1 = Discount.create!(quantity: 5, percentage: 20, merchant_id: @merchant_1.id)
      discount_2 = Discount.create!(quantity: 10, percentage: 25, merchant_id: @merchant_1.id)
      
      visit '/merchant/discounts'

      within "#discount-#{discount_1.id}" do
        click_link 'Edit'
      end
      
      expect(current_path).to eq("/merchant/discounts/#{discount_1.id}/edit")

    end

    it 'When I fill out the edit form completely, I am returned to the discount index and see the updated discount' do
      discount_1 = Discount.create!(quantity: 5, percentage: 20, merchant_id: @merchant_1.id)
      
      visit "/merchant/discounts/#{discount_1.id}/edit"

      fill_in 'Quantity', with: 10
      fill_in 'Percentage', with: 30
      click_button 'Update Discount'

      expect(current_path).to eq("/merchant/discounts")

      within "#discount-#{discount_1.id}" do
        expect(page).to have_content("30 percent off 10 items")
        expect(page).to_not have_content("20 percent off 5 items")
      end
    end

    it 'When I fill out the edit form incompletely, I see a message and I am returned to the discount edit form' do
      discount_1 = Discount.create!(quantity: 5, percentage: 20, merchant_id: @merchant_1.id)
      
      visit "/merchant/discounts/#{discount_1.id}/edit"

      fill_in 'Quantity', with: ""
      fill_in 'Percentage', with: ""
      click_button 'Update Discount'

      expect(page).to have_content("percentage: [\"Percentage must be 1 - 99\"]")
      expect(page).to have_content("[\"is not a number\"]")
      expect(page).to have_content('Edit Discount')
      
    end
  end
end