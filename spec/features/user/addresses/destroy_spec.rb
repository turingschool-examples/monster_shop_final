require 'rails_helper'

RSpec.describe "Address destruction" do
  describe "As a registered user" do
    before :each do
      @user = User.create!(name: 'Megan', email: 'megan@example.com', password: 'securepassword')
      @address_1 = @user.addresses.create!(street_address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @address_2 = @user.addresses.create!(street_address: '456 Main st', city: 'Dallas', state: 'TX', zip: 75402, nickname: 'Work')
    end

    it "I can delete address from my profile page and select a new one" do
      address_3 = @user.addresses.create!(street_address: '123 Bad st', city: 'Badville', state: 'NY', zip: 12034, nickname: 'dealer')

      visit login_path
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log In'
      visit profile_path

      within "#current-address" do
        expect(page).to have_link("Delete Current Address")
        click_link 'Delete Current Address'
      end

      expect(current_path).to eq(addresses_path)
      expect(page).to have_content("You have deleted your Home address.")
      expect(page).to have_content("You should choose or create a new default address")
      expect(page).to have_link('Back to My Profile')
      expect(page).to have_link('Add New Address')

      within "#address-#{@address_2.id}" do
        expect(page).to have_link('Set as Default Address')
      end

      within "#address-#{address_3.id}" do
        expect(page).to have_link('Set as Default Address')
        click_link 'Set as Default Address'
      end

      expect(current_path).to eq(profile_path)
      expect(page).to have_content("You have set '#{address_3.nickname}' as your default address")

      @user.reload
      expect(@user.my_address).to eq(address_3)

      within "#current-address" do
        expect(page).to have_content("Current Address: Dealer")
        expect(page).to have_content(address_3.street_address)
        expect(page).to have_content("#{address_3.city}, #{address_3.state} #{address_3.zip}")
      end
    end

    it "Automatically sets my only remaining address to default when I delete my current address from profile page" do
      visit login_path
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log In'
      visit profile_path

      expect(@user.my_address).to eq(@address_1)

      within "#current-address" do
        expect(page).to have_content("Current Address: Home")
        expect(page).to have_content(@address_1.street_address)
        expect(page).to have_content("#{@address_1.city}, #{@address_1.state} #{@address_1.zip}")
        expect(page).to have_link("Delete Current Address")
        click_link 'Delete Current Address'
      end

      expect(current_path).to eq(profile_path)
      expect(page).to have_content("#{@address_2.nickname} has been set to your default address")
      expect(page).to have_content("You have deleted your Home address.")
      @user.reload
      expect(@user.default_address).to eq(@address_2.id)

      within "#current-address" do
        expect(page).to have_content("Current Address: Work")
        expect(page).to have_content(@address_2.street_address)
        expect(page).to have_content(@address_2.city)
        expect(page).to have_content(@address_2.state)
        expect(page).to have_content(@address_2.zip)
      end
    end

    it "Automatically sets my only remaining address to default when I delete my current address from address index page" do
      visit login_path
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log In'
      visit addresses_path

      expect(@user.my_address).to eq(@address_1)

      within "#address-#{@address_2.id}" do
        expect(page).to have_content('Work')
        expect(page).to have_link('Set as Default Address')
        expect(page).to have_link('Edit Address')
        expect(page).to have_link('Delete Address')
      end

      within "#address-#{@address_1.id}" do
        expect(page).to have_content('Home')
        expect(page).to_not have_link('Set as Default Address')
        expect(page).to have_link('Edit Address')
        expect(page).to have_link('Delete Address')
        click_link 'Delete Address'
      end

      @user.reload
      expect(current_path).to eq(profile_path)
      expect(@user.my_address).to eq(@address_2)

      expect(page).to have_content("#{@address_2.nickname} has been set to your default address")
      expect(page).to have_content("You have deleted your Home address.")
    end

    it "Wont let me delete addresses that have been used in shipped orders" do
      megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      ogre = megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      user = User.create!(name: 'Megan', email: 'megan_1example.com', password: 'securepassword')
      address_1 = user.addresses.create!(street_address: '123 Bad st', city: 'Badville', state: 'NY', zip: 12034)
      expect(user.my_address).to eq(address_1)
      address_2 = user.addresses.create!(street_address: '456 Main st', city: 'Dallas', state: 'TX', zip: 75402, nickname: 'Work')

      order_1 = user.orders.create!(address_id: address_1.id, status: 'shipped')
      order_1.order_items.create!(item: ogre, price: ogre.price, quantity: 2)

      visit login_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Log In'
      visit profile_path

      within "#current-address" do
        expect(page).to have_content("Current Address: Home")
        expect(page).to have_content(address_1.street_address)
        expect(page).to have_content(address_1.city)
        expect(page).to have_content(address_1.state)
        expect(page).to have_content(address_1.zip)
        expect(page).to_not have_link('Delete Current Address')
        click_link 'All Addresses'
      end

      expect(current_path).to eq(addresses_path)

      within "#address-#{address_1.id}" do
        expect(page).to have_content('Home')
        expect(page).to_not have_link('Set as Default Address')
        expect(page).to_not have_link('Edit Address')
        expect(page).to_not have_link('Delete Address')
      end

      within "#address-#{address_2.id}" do
        expect(page).to have_content('Work')
        expect(page).to have_link('Set as Default Address')
        expect(page).to have_link('Delete Address')
        expect(page).to have_link('Edit Address')
        click_link 'Delete Address'
      end

      expect(current_path).to eq(profile_path)
      expect(page).to have_content("You have deleted your Work address.")
    end
  end
end
