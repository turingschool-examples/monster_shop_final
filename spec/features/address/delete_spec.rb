require 'rails_helper'

RSpec.describe 'Delete Address' do
  before :each do
    @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
    @merchant_2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)

    @m_user = @merchant_1.users.create(name: 'Megan', email: 'megan@example.com', password: 'securepassword')

    visit login_path

    fill_in 'Email', with: 'megan@example.com'
    fill_in 'Password', with: 'securepassword'
    click_button 'Log In'

    @address_1 = Address.create!(nickname: 'Home', address: '1776 Independence Blvd', city: 'Boston', state: 'MA', zip: 80218, user_id: @m_user.id)
    @address_2 = Address.create!(nickname: 'Work', address: '1790 Democracy Ln', city: 'Washington', state: 'DC', zip: 80218, user_id: @m_user.id)
    @address_3 = Address.create!(nickname: 'Vacation', address: '1969 Eagle Rd', city: 'Houston', state: 'TX', zip: 80218, user_id: @m_user.id)

    @ogre = @merchant_1.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
    @giant = @merchant_1.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
    @hippo = @merchant_2.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 1 )

    @order_1 = @m_user.orders.create!(status: "pending", address_id: @address_1.id)
    @order_2 = @m_user.orders.create!(status: "shipped", address_id: @address_2.id)

    @order_item_1 = @order_1.order_items.create!(item: @hippo, price: @hippo.price, quantity: 2, fulfilled: false)
    @order_item_2 = @order_2.order_items.create!(item: @hippo, price: @hippo.price, quantity: 2, fulfilled: true)
    @order_item_3 = @order_2.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: true)
    @order_item_4 = @order_2.order_items.create!(item: @giant, price: @giant.price, quantity: 2, fulfilled: true)
  end

  describe 'As a registered user, when I visit my profile page' do
    it 'I can delete an address by clicking a link' do
        visit profile_path

        expect(current_path).to eq('/profile')

        within "#address-#{@address_3.id}" do
          expect(page).to have_content('Vacation')
          click_link 'Delete Address'
        end

        expect(current_path).to eq(profile_path)

        within "#address-#{@address_1.id}" do
          expect(page).to have_content('Home')
          expect(page).to have_link('Delete Address')
        end

        within "#address-#{@address_2.id}" do
          expect(page).to have_content('Work')
          expect(page).to have_link('Delete Address')
        end

        expect(page).to_not have_css("#address-#{@address_3.id}")
      end
    end
  describe 'As a registered user' do
    it 'I cannot delete an address if its associated to a shipped order' do
      visit profile_path

      expect(current_path).to eq('/profile')

      within "#address-#{@address_2.id}" do
        expect(page).to have_content('Work')
        click_link 'Delete Address'
      end

      expect(current_path).to eq(profile_path)
      expect(page).to have_content("Address can't be deleted")

      within "#address-#{@address_1.id}" do
        expect(page).to have_content('Home')
        expect(page).to have_link('Delete Address')
      end

      within "#address-#{@address_2.id}" do
        expect(page).to have_content('Work')
        expect(page).to have_link('Delete Address')
      end

      within "#address-#{@address_3.id}" do
        expect(page).to have_content('Vacation')
        expect(page).to have_link('Delete Address')
      end
    end
  end
end
