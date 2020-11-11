require 'rails_helper'

RSpec.describe 'Discount Show Page' do
  describe 'As a Merchant Employee' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_user = @megan.users.create!(name: "Hope", address: "456 Space st", city: "Space", state: "CO", zip: 80111, email: "Hope@example.com", password: "superEasyPZ", role: 1)
      @orge = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @order_1 = @merchant_user.orders.create!(status: 'pending')
      @order_2 = @merchant_user.orders.create!(status: 'pending')
      @order_3 = @merchant_user.orders.create!(status: 'pending')
      @order_4 = @merchant_user.orders.create!(status: 'pending')
      @order_item_1 = @order_1.order_items.create!(item: @orge, price: @orge.price, quantity: 3, fulfilled: false)
      @order_item_2 = @order_2.order_items.create!(item: @giant, price: @giant.price, quantity: 4, fulfilled: false)
      @order_item_3 = @order_3.order_items.create!(item: @hippo, price: @hippo.price, quantity: 3, fulfilled: false)
      @order_item_4 = @order_4.order_items.create!(item: @hippo, price: @orge.price, quantity: 4, fulfilled: false)
      @order_item_5 = @order_1.order_items.create!(item: @giant, price: @giant.price, quantity: 3, fulfilled: true)
      @order_item_6 = @order_2.order_items.create!(item: @orge, price: @orge.price, quantity: 4, fulfilled: true)
      @megan_discount_1 = @megan.discounts.create!(description: "Buy 5 items, get 5% off ", quantity: 5, percent: 5)
      @megan_discount_2 = @megan.discounts.create!(description: "Buy 10 items, get 25% off ", quantity: 10, percent: 25)
      @brian_discount_3 = @brian.discounts.create!(description: "Buy 10 items, get 45% off ", quantity: 10, percent: 45, enable: false)
      @brian_discount_4 = @brian.discounts.create!(description: "Buy 5 items, get 10% off ", quantity: 5, percent: 10)
      @brian_discount_5 = @brian.discounts.create!(description: "Buy 6 items, get 30% off ", quantity: 6, percent: 30)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
    end

    it 'can the particulars of the unique discount' do
      visit "/merchant/discounts/#{@megan_discount_1.id}"

      expect(page).to have_content("Description of Discount: #{@megan_discount_1.description}")
      expect(page).to have_content("Quantity of minimum items needed for the discount: #{@megan_discount_1.quantity}")
      expect(page).to have_content("Percent Off: #{@megan_discount_1.percent}%")
    end

    it 'can enable a discount from the show page' do
      visit "/merchant/discounts/#{@brian_discount_3.id}"

      expect(page).to have_content('Status: Disabled')
      expect(page).to have_button('Enable Discount')
      click_button 'Enable Discount'

      expect(page).to have_content('Status: Enabled')
      expect(page).to have_button('Disable Discount')
    end

    it 'can disable a discount from the show page' do
      visit "/merchant/discounts/#{@brian_discount_4.id}"
      expect(page).to have_content('Status: Enabled')
      expect(page).to have_button('Disable Discount')
      click_button 'Disable Discount'
      expect(page).to have_content('Status: Disabled')
      expect(page).to have_button('Enable Discount')
    end
  end
end
