require 'rails_helper'

RSpec.describe 'Merchant Order Show Page' do
  describe 'As a Merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @discount_1_5 = @merchant_1.discounts.create(name: '5 Percent', percentage: 0.05, limit: 5)
      @discount_1_10 = @merchant_1.discounts.create(name: '10 Percent', percentage: 0.1, limit: 10)
      @ogre = @merchant_1.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 20 )
      @giant = @merchant_1.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 20 )
      @hippo = @merchant_2.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 20 )
      @order_1 = @m_user.orders.create!(status: "pending")
      @order_2 = @m_user.orders.create!(status: "pending")
      @order_item_1 = @order_1.order_items.create!(item: @hippo, price: @hippo.price, quantity: 5, fulfilled: false)
      @order_item_2 = @order_2.order_items.create!(item: @hippo, price: @hippo.price, quantity: 10, fulfilled: true)
      @order_item_3 = @order_2.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: false)
      @order_item_4 = @order_2.order_items.create!(item: @giant, price: @giant.price, quantity: 15, fulfilled: false)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'Index for discounts' do
      visit '/merchant/items'

      expect(page).to have_link("Current Discounts")
      click_link "Current Discount"

      expect(current_path).to eq('/merchant/discounts')
      expect(page).to have_link("Create Discount")

      within "#discount-#{@discount_1_5.id}" do
        expect(page).to have_content("#{@discount_1_5.name} Discount")
        expect(page).to have_content("Limit: #{@discount_1_5.limit}")
        expect(page).to have_link("Update")
        expect(page).to have_button("Delete")
      end

      within "#discount-#{@discount_1_10.id}" do
        expect(page).to have_content("#{@discount_1_10.name} Discount")
        expect(page).to have_content("Limit: #{@discount_1_10.limit}")
        expect(page).to have_link("Update")
        expect(page).to have_button("Delete")
      end
    end
  end
end
