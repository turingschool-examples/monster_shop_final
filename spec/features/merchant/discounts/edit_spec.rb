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
      @megan_discount_1 = @megan.discounts.create!(description: "Buy 5 items, get 5% off", quantity: 5, percent: 5)
      @megan_discount_2 = @megan.discounts.create!(description: "Buy 10 items, get 25% off", quantity: 10, percent: 25)
      @brian_discount_3 = @brian.discounts.create!(description: "Buy 10 items, get 45% off", quantity: 10, percent: 45)
      @brian_discount_4 = @brian.discounts.create!(description: "Buy 5 items, get 10% off", quantity: 5, percent: 10)
      @brian_discount_5 = @brian.discounts.create!(description: "Buy 6 items, get 30% off", quantity: 6, percent: 30)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
    end

    it 'can edit a discount' do
      visit "/merchant/discounts/#{@megan_discount_2.id}"

      expect(page).to have_link('Edit Discount')
      click_link 'Edit Discount'

      expect(current_path).to eq("/merchant/discounts/#{@megan_discount_2.id}/edit")

      expect(page).to have_content("#{@megan_discount_2.id}'s Edit Page")
      expect(page).to have_field(:description, with: @megan_discount_2.description)

      new_discount_description = 'Buy 10 items, get 30% off'
      new_discount_percent = 30

      fill_in :description, with: new_discount_description
      fill_in :percent, with: new_discount_percent

      click_button 'Update Discount'

      expect(current_path).to eq("/merchant/discounts/#{@megan_discount_2.id}")
      expect(page).to have_content('You successfully updated your discount!')
      expect(page).to have_content("Description of Discount: #{new_discount_description}")
      expect(page).to have_content("Percent Off: #{new_discount_percent}")
    end

    it 'cannot leave a field blank and still update a discount' do
      visit "/merchant/discounts/#{@megan_discount_2.id}"

      expect(page).to have_link('Edit Discount')
      click_link 'Edit Discount'

      expect(current_path).to eq("/merchant/discounts/#{@megan_discount_2.id}/edit")

      expect(page).to have_content("#{@megan_discount_2.id}'s Edit Page")
      expect(page).to have_field(:description, with: @megan_discount_2.description)

      new_discount_description = 'Buy 10 items, get 30% off'
      new_discount_percent = ''

      fill_in :description, with: new_discount_description
      fill_in :percent, with: new_discount_percent

      click_button 'Update Discount'

      expect(current_path).to eq("/merchant/discounts/#{@megan_discount_2.id}")
      expect(page).to have_content('You cannot leave a field blank. Please fully fill out the form')
      expect(page).to have_content("#{@megan_discount_2.id}'s Edit Page")
    end
  end
end
