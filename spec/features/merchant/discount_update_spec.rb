require 'rails_helper'

RSpec.describe 'Discount Update Page' do
  describe 'As an employee of a merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @ogre = @merchant_1.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 80 )
      @giant = @merchant_1.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 80 )
      @hippo = @merchant_2.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 80 )
      @order_1 = @m_user.orders.create!(status: "pending")
      @order_2 = @m_user.orders.create!(status: "pending")
      @order_3 = @m_user.orders.create!(status: "pending")
      @discount1 = @merchant_1.discounts.create!(percent_off: 5, quantity_threshold: 20, status: "active")
      @discount2 = @merchant_1.discounts.create!(percent_off: 10, quantity_threshold: 40, status: "active")
      @discount3 = @merchant_1.discounts.create!(percent_off: 5, quantity_threshold: 2, status: "inactive")
      @discount4 = @merchant_1.discounts.create!(percent_off: 5, quantity_threshold: 2, status: "active")
      @order_item_1 = @order_1.order_items.create!(item: @hippo, price: @hippo.price, quantity: 2, fulfilled: false)
      @order_item_2 = @order_2.order_items.create!(item: @hippo, price: @hippo.price, quantity: 2, fulfilled: true)
      @order_item_3 = @order_2.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: false, discount_id: @discount3.id)
      @order_item_4 = @order_3.order_items.create!(item: @giant, price: @giant.price, quantity: 2, fulfilled: false, discount_id: @discount4.id)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it "can use the link at the show page and update the discount" do
      visit "/merchant/discounts/#{@discount1.id}"

      click_link "Edit Discount"

      expect(current_path).to eq("/merchant/discounts/#{@discount1.id}/edit")

      expect(find_field(:percent_off).value.to_i).to eq(@discount1.percent_off)
      expect(find_field(:quantity_threshold).value.to_i).to eq(@discount1.quantity_threshold)
      expect(find_field(:status).value).to eq(@discount1.status)

      fill_in 'percent_off', with: "25"
      fill_in 'quantity_threshold', with: "50"
      fill_in 'status', with: "inactive"

      click_on "Update Discount"

      expect(current_path).to eq("/merchant/discounts/#{@discount1.id}")

      expect(page).to have_content("Percent off: 25")
      expect(page).to have_content("Amount needed to trigger discount: 50")
      expect(page).to_not have_content("Percent off: 5")
      expect(page).to have_content("Status: inactive")
      expect(page).to_not have_content("Amount needed to trigger discount: 20")
      expect(page).to_not have_content("Status: active")
    end

    it "can't edit with incomplete fields" do
      visit "/merchant/discounts/#{@discount1.id}"

      click_link "Edit Discount"

      expect(current_path).to eq("/merchant/discounts/#{@discount1.id}/edit")

      expect(find_field(:percent_off).value.to_i).to eq(@discount1.percent_off)
      expect(find_field(:quantity_threshold).value.to_i).to eq(@discount1.quantity_threshold)
      expect(find_field(:status).value).to eq(@discount1.status)

      fill_in 'percent_off', with: ""
      fill_in 'quantity_threshold', with: ""


      click_on "Update Discount"

      expect(current_path).to eq("/merchant/discounts/#{@discount1.id}/edit")
      expect(find_field(:percent_off).value.to_i).to eq(@discount1.percent_off)
      expect(find_field(:quantity_threshold).value.to_i).to eq(@discount1.quantity_threshold)
      expect(find_field(:status).value).to eq(@discount1.status)

    end
# user story 5
    it "can't update the percent or threshold of the discount if it has been used in an order" do
      order_5 = @m_user.orders.create!(status: "pending")

      order_item_6 = order_5.order_items.create!(item: @ogre, price: @ogre.price, quantity: 20, fulfilled: false, discount_id: @discount1.id)
      order_item_7 = order_5.order_items.create!(item: @giant, price: @giant.price, quantity: 20, fulfilled: false, discount_id: @discount1.id)

      visit "/merchant/discounts/#{@discount1.id}"

      expect(page).to_not have_content("Edit Discount")
    end

    it "can change the status of a discount if it has or has not been used" do
#       @order_item_1 = @order_1.order_items.create!(item: @hippo, price: @hippo.price, quantity: 2, fulfilled: false)
#       @order_item_2 = @order_2.order_items.create!(item: @hippo, price: @hippo.price, quantity: 2, fulfilled: true)
#       @order_item_3 = @order_2.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: false, discount_id: @discount3.id)
#       @order_item_4 = @order_3.order_items.create!(item: @giant, price: @giant.price, quantity: 2, fulfilled: false, discount_id: @discount4.id)
# 3 inactive, been used.
# 4 active, been used.

      visit "/merchant/discounts/#{@discount1.id}"

      expect(page).to_not have_button("Deactivate Discount")
      expect(page).to_not have_button("Activate Discount")

      expect(page).to have_content("Status: active")
      expect(page).to have_link("Edit Discount")

      visit "/merchant/discounts/#{@discount2.id}"

      expect(page).to_not have_button("Deactivate Discount")
      expect(page).to_not have_button("Activate Discount")

      expect(page).to have_content("Status: active")
      expect(page).to have_link("Edit Discount")

      visit "/merchant/discounts/#{@discount3.id}"

      expect(page).to_not have_button("Deactivate Discount")
      click_on "Activate Discount"

      expect(current_path).to eq("/merchant/discounts/#{@discount3.id}")
      expect(page).to have_content("Status: active")
      expect(page).to have_button("Deactivate Discount")
      expect(page).to_not have_button("Activate Discount")

      visit "/merchant/discounts/#{@discount4.id}"

      expect(page).to have_button("Deactivate Discount")
      click_on "Deactivate Discount"

      expect(current_path).to eq("/merchant/discounts/#{@discount4.id}")
      expect(page).to have_content("Status: inactive")
      expect(page).to have_button("Activate Discount")
    end
  end
end
