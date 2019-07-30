require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Update Order Address' do
  describe 'As a Registered User' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @sal = Merchant.create!(name: 'Sals Salamanders', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)

      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 1 )

      @user = User.create!(name: 'Megan', email: 'megan@example.com', password: 'securepassword')

      visit login_path
      fill_in 'Email', with: 'megan@example.com'
      fill_in 'Password', with: 'securepassword'
      click_button 'Log In'

      @address_1 = Address.create!(nickname: 'Home', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, user_id: @user.id)
      @address_2 = Address.create!(nickname: 'Work', address: '12 Market St', city: 'Denver', state: 'CO', zip: 80218, user_id: @user.id)

      @order_1 = @user.orders.create!(status: "packaged", address_id: @address_1.id)
      @order_2 = @user.orders.create!(status: "pending", address_id: @address_1.id)

      @order_item_1 = @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: true)
      @order_item_2 = @order_2.order_items.create!(item: @giant, price: @hippo.price, quantity: 2, fulfilled: true)
      @order_item_3 = @order_2.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: false)
    end

    it 'I can change the address of an order if order is still pending' do
      visit profile_orders_path

      click_link @order_2.id

      click_link 'Change Order Address'

      expect(current_path).to eq(change_address_path(@order_2.id))

      within "#address-#{@address_2.id}" do
        expect(page).to have_content('Work')
        click_button 'Use this address'
      end

      expect(current_path).to eq("/profile/orders/#{@order_2.id}")

      expect(page).to have_content('Address has been changed successfully')
      expect(page).to have_content('Work')
      expect(page).to have_content('12 Market St')
    end

    it "I can't change an address on a non pending order" do
      visit profile_orders_path

      click_link @order_1.id

      expect(page).to_not have_link('Change Order Address')
      expect(page).to have_content('packaged')
    end
  end
end
