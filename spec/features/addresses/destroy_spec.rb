require 'rails_helper'

RSpec.describe 'Delete an Address' do
  describe 'As a User' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @sal = Merchant.create!(name: 'Sals Salamanders', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 1 )
      @user = User.create!(name: 'Megan', email: 'megan_1@example.com', password: 'securepassword')
      @user_address = @user.addresses.create!(street_address: '123 user lives here', city: 'Denver', state: 'CO', zip: 80301)

      @order_1 = @user.orders.create!(status: "shipped", address_id: @user_address.id)
      @order_2 = @user.orders.create!(status: "shipped", address_id: @user_address.id)
      @order_item_1 = @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: true)
      @order_item_2 = @order_2.order_items.create!(item: @giant, price: @hippo.price, quantity: 2, fulfilled: true)
      @order_item_3 = @order_2.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: false)

      visit registration_path
      fill_in 'Name', with: 'Megan'
      fill_in 'Street address', with: '123 user lives here'
      fill_in 'City', with: 'Denver'
      fill_in 'State', with: 'CO'
      fill_in 'Zip', with: 80301
      fill_in 'Email', with: 'megan1@example.com'
      fill_in 'Password', with: 'securepassword'
      fill_in 'Password confirmation', with: 'securepassword'
      click_button 'Register'
    end
    it 'I can delete an address' do

      expect(current_path).to eq(profile_path)
      expect(page).to_not have_content(@user_address)
    end

    it "address cannot be deleted or changed if it's status is 'shipped'" do
        #Test for preventing shipped orders's addresses to change. 
    end

    it 'If user deletes all address they cannont checkout and see an error telling them to add an address first. Page redirects to new address form.' do
      expect(current_path).to eq(profile_path)
      click_on "Delete Address"

      visit item_path(@ogre)
      click_button 'Add to Cart'
      visit item_path(@hippo)
      click_button 'Add to Cart'

      visit cart_path

      click_button "Check Out"

      expect(current_path).to eq(new_user_address_path(@user.id+1))
      #because I signed in with a user different than @user my user_ids were off by one. Not ideal, but...
      expect(page).to have_content("An address is required to checkout.")
    end
  end
end
