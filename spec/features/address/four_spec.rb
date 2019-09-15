require 'rails_helper'
RSpec.describe "Choose Address At Cart Checkout" do
  describe "As a registered user with more than one address" do
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

      visit cart_path
    end
    it "I see my options" do
      click_on "Check Out"

      expect(page).to have_content("Choose Your Shipping Address")

      expect(page).to have_content(@user_address.address)
      expect(page).to have_content(@user_address.city)
      expect(page).to have_content(@user_address.state)
      expect(page).to have_content(@user_address.zip)

      expect(page).to have_content(@user_address_2.address)
      expect(page).to have_content(@user_address_2.city)
      expect(page).to have_content(@user_address_2.state)
      expect(page).to have_content(@user_address_2.zip)

      within "#address-#{@user_address.id}" do
        click_on "Choose This Address"
        order = Order.last
        expect(current_path).to eq('/profile/orders')
        expect(order.address).to eq(@user_address)
        expect(order.address).to_not eq(@user_address_2)
      end
    end
  end
end
