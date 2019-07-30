require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Create Order' do
  describe 'As a Registered User' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)

      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )

      @user = User.create!(name: 'Megan', email: 'megan@example.com', password: 'securepassword')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      @address_1 = Address.create!(nickname: 'Home', address: '1776 Independence Blvd', city: 'Boston', state: 'MA', zip: 80218, user_id: @user.id)
      @address_2 = Address.create!(nickname: 'Work', address: '1790 Democracy Ln', city: 'Washington', state: 'DC', zip: 80218, user_id: @user.id)
      @address_3 = Address.create!(nickname: 'Vacation', address: '1969 Eagle Rd', city: 'Houston', state: 'TX', zip: 80218, user_id: @user.id)
    end

    it 'I can click a link to get to create an order' do
      visit item_path(@ogre)
      click_button 'Add to Cart'
      visit item_path(@hippo)
      click_button 'Add to Cart'
      visit item_path(@hippo)
      click_button 'Add to Cart'

      visit '/cart'

      click_button 'Check Out'

      expect(current_path).to eq(select_address_path)

      within "#address-#{@address_3.id}" do
        expect(page).to have_content('Vacation')
        click_button 'Use this address'
      end

      order = Order.last

      expect(current_path).to eq('/profile/orders')
      expect(page).to have_content('Order created successfully!')
      expect(page).to have_link('Cart: 0')

      within "#order-#{order.id}" do
        expect(page).to have_link(order.id)
      end
    end
  end

  describe 'As a Visitor' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
    end

    it "I see a link to log in or register to check out" do
      visit item_path(@ogre)
      click_button 'Add to Cart'
      visit item_path(@hippo)
      click_button 'Add to Cart'
      visit item_path(@hippo)
      click_button 'Add to Cart'

      visit '/cart'

      expect(page).to_not have_button('Check Out')

      within '#checkout' do
        click_link 'register'
      end

      expect(current_path).to eq(registration_path)

      visit '/cart'

      within '#checkout' do
        click_link 'log in'
      end

      expect(current_path).to eq(login_path)
    end
  end

  describe 'As a registered user' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)

      @user = User.create!(name: 'Gavin', email: 'gavin@example.com', password: 'securepassword')

      visit login_path

      fill_in 'Email', with: 'gavin@example.com'
      fill_in 'Password', with: 'securepassword'
      click_button 'Log In'

      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
    end

    it "When I checkout without a address, I see a error that I need to create an address to continue" do
      visit item_path(@ogre)
      click_button 'Add to Cart'
      visit item_path(@hippo)
      click_button 'Add to Cart'
      visit item_path(@hippo)
      click_button 'Add to Cart'

      visit '/cart'

      click_button 'Check Out'

      expect(page).to have_content("Address must be added to continue checkout")

      expect(current_path).to eq(new_address_path)

      fill_in 'Nickname', with: 'Work'
      fill_in 'Address', with: '1776 Independence'
      fill_in 'City', with: 'Boston'
      fill_in 'State', with: 'MA'
      fill_in 'Zip', with: '80218'
      click_button 'Create Address'

      address = Address.last
      expect(current_path).to eq(profile_path)

      visit '/cart'

      click_button 'Check Out'

      within "#address-#{address.id}" do
        expect(page).to have_content('Work')
        click_button 'Use this address'
      end

      expect(current_path).to eq('/profile/orders')
      expect(page).to have_content('Order created successfully!')
      expect(page).to have_link('Cart: 0')
    end
  end
end
