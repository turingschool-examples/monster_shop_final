require 'rails_helper'

RSpec.describe "As a merchant user" do
  describe "when i visit the coupon index page", type: :feature do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @ogre = @merchant_1.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @merchant_1.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @merchant_2.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 1 )
      @order_1 = @m_user.orders.create!(status: "pending")
      @order_2 = @m_user.orders.create!(status: "pending")
      @order_3 = @m_user.orders.create!(status: "pending")
      @order_item_1 = @order_1.order_items.create!(item: @hippo, price: @hippo.price, quantity: 2, fulfilled: false)
      @order_item_2 = @order_2.order_items.create!(item: @hippo, price: @hippo.price, quantity: 2, fulfilled: true)
      @order_item_3 = @order_2.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: false)
      @order_item_4 = @order_3.order_items.create!(item: @giant, price: @giant.price, quantity: 2, fulfilled: false)

      @half_off_mm = Coupon.create(
        name:       "Half off Megans",
        code:       00001,
        percentage: 50
      )

      @fourth_off_mm = Coupon.create(
        name:       "Fourth off Megans",
        code:       00002,
        percentage: 25
      )

      @half_off_bb = Coupon.create(
        name:       "Half off Brians",
        code:       00003,
        percentage: 50
      )

      @fourth_off_bb = Coupon.create(
        name:       "Fourth off Brians",
        code:       00004,
        percentage: 25
      )

      @merchant_1.coupons << [@half_off_mm, @fourth_off_mm]
      @merchant_2.coupons << [@half_off_bb, @fourth_off_bb]

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)

      visit '/merchant/coupons'
    end

    it "i see all coupons and info for that merchant" do
      expect(page).to have_content('Half off Megans')
      expect(page).to_not have_content('Half off Brians')
      expect(page).to have_content('Fourth off Megans')
    end

    it "i can create a new coupon" do
      click_link 'New Coupon'
      expect(current_path).to eq("/merchant/coupons/new")

      fill_in 'Name', with: 'Third off Megans'
      fill_in 'Code', with: '00005'
      fill_in 'Percentage', with: '33'

      click_on 'Create Coupon'
      expect(current_path).to eq('/merchant/coupons')

      expect(page).to have_content('Third off Megans')
    end
  end
end
