require 'rails_helper'

RSpec.describe "User Deletes Addresses" do
  describe "As a user with multiple addresses" do
    before :each do
      @user = User.create!(name: 'Megan', email: 'megan@example.com', password: 'securepassword')
      @user_address = @user.addresses.create!(address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, nickname: "Home")
      @user_address_2 = @user.addresses.create!(address: '123 Iguana Way', city: 'Miami', state: 'FL', zip: 34109, nickname: "School")
      visit login_path

      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log In'
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)

      @ogre = @merchant_1.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @nessie = @merchant_1.items.create!(name: 'Nessie', description: "I'm a Loch Monster!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @merchant_1.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: false, inventory: 3 )

      visit item_path(@ogre)
      click_on "Add to Cart"

      visit item_path(@nessie)
      click_on "Add to Cart"

      visit item_path(@giant)
      click_on "Add to Cart"
    end
    it "If a user deletes all of their addresses, they cannot check out
    and see an error telling them they need to add an address first.
    This should link to a page where they add an address." do
      visit profile_path

      within "#address-#{@user_address.id}" do
        click_on "Delete This Address"
      end

      within "#address-#{@user_address_2.id}" do
        click_on "Delete This Address"
      end

      visit cart_path
      expect(page).to_not have_button("Check Out")
      expect(page).to have_content("Before you can check out, you must add an address")
      expect(page).to have_link("add an address")

      click_on "add an address"
      expect(current_path).to eq(new_user_address_path)
    end
  end
end
