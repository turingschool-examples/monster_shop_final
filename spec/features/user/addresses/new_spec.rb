require 'rails_helper'

RSpec.describe 'User Profile Page' do
  describe 'As a Registered User' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @sal = Merchant.create!(name: 'Sals Salamanders', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @user = User.create!(name: 'Megan', email: 'megan_1@example.com', password: 'securepassword')
      @address = @user.addresses.create(streetname: "123 market", city: "Denver", state: "CO", zip: 80132)
      @address2 = @user.addresses.create(streetname: "123 main", city: "Springfield", state: "IL", zip: 12345)
      @order_1 = @user.orders.create!(address_id: @address.id)
      @order_2 = @user.orders.create!(address_id: @address.id)
      @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2)
      @order_2.order_items.create!(item: @giant, price: @hippo.price, quantity: 2)
      @order_2.order_items.create!(item: @ogre, price: @hippo.price, quantity: 2)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end
    it "user can create a new address" do
      visit "/profile"

      within ".address" do
        click_on "New Address"
        expect(current_path).to eq(address_new_path)
      end

      address2 = @user.addresses.create(streetname: "123 main", city: "Springfield", state: "IL", zip: 12345)


      fill_in 'Streetname', with: address2.streetname
      fill_in 'City', with: address2.city
      fill_in 'State', with: address2.state
      fill_in 'Zip', with: address2.zip

      click_button "Submit"

      expect(current_path).to eq(profile_path)

      expect(page).to have_content(address2.nickname)
      expect(page).to have_content(address2.streetname)
      expect(page).to have_content(address2.city)
      expect(page).to have_content(address2.state)
      expect(page).to have_content(address2.zip)

    end

    it "user can be sent back to new" do
      visit "/profile"

      within ".address" do
        click_on "New Address"
        expect(current_path).to eq(address_new_path)
      end

      streetname = "123 main"
      city = "Springfield"
      state = "IL"

      fill_in 'Streetname', with: streetname
      fill_in 'City', with: city
      fill_in 'State', with: state


      click_button "Submit"


      expect(page).to have_content("zip: [\"can't be blank\"]")


    end

  end
end
