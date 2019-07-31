require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Order Address doesnt exist' do
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

      @address = Address.create!(nickname: 'Home', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, user_id: @user.id)

      @order = @user.orders.create!(status: "pending", address_id: @address.id)

      @order_item_1 = @order.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: true)
    end

    it 'User has to create and assign an address if all addresses have been deleted' do
      visit profile_path

      expect(current_path).to eq('/profile')

      within "#address-#{@address.id}" do
        expect(page).to have_content('Home')
        click_link 'Delete Address'
      end

      expect(current_path).to eq(profile_path)

      click_link 'My Orders'

      within "#order-#{@order.id}" do
        click_link "#{@order.id}"
      end

      expect(current_path).to eq(new_address_path)
      expect(page).to have_content("Order is missing address, create address to proceed")

      address = Address.create!(nickname: 'Home', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, user_id: @user.id)

      visit profile_path

      click_link 'My Orders'

      within "#order-#{@order.id}" do
        click_link "#{@order.id}"
      end

      expect(current_path).to eq(change_address_path(@order.id))
      expect(page).to have_content("Address must be associated with order, select an address")
    end
  end
end
