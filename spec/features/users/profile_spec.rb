require 'rails_helper'

RSpec.describe "User Profile Path" do
  describe "As a registered user" do
    before :each do
      @user = User.create!(name: 'Megan', email: 'megan@example.com', password: 'securepassword')
      @admin = User.create!(name: 'Megan', email: 'admin@example.com', password: 'securepassword', role: 2)
      @address_1 = @user.addresses.create!(address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218) #Default nickname should be 'home'
      @address_2 = @user.addresses.create!(address: '456 Main st', city: 'Dallas', state: 'TX', zip: 75402, nickname: 'Work')
    end

    it "I can view my profile page" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit profile_path

      expect(page).to have_content(@user.name)
      expect(page).to have_content(@user.email)
      expect(page).to have_content('123 Main St')
      expect(page).to have_content("Denver, CO 80218")
      expect(page).to_not have_content(@user.password)
      expect(page).to have_link('Edit Profile')
    end

    it "I can update my profile data" do
      visit login_path

      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log In'

      click_link 'Edit Profile'

      expect(current_path).to eq('/profile/edit')

      name = 'New Name'
      email = 'new@example.com'

      fill_in "Name", with: name
      fill_in "Email", with: email
      click_button 'Update Profile'

      expect(current_path).to eq(profile_path)

      expect(page).to have_content('Profile has been updated!')
      expect(page).to have_content(name)
      expect(page).to have_content(email)
    end

    it "I can update my password" do
      visit login_path

      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log In'

      click_link 'Change Password'

      expect(current_path).to eq('/profile/edit_password')

      password = "newpassword"

      fill_in "Password", with: password
      fill_in "Password confirmation", with: password
      click_button 'Change Password'

      expect(current_path).to eq(profile_path)

      expect(page).to have_content('Profile has been updated!')

      click_link 'Log Out'

      visit login_path

      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log In'

      expect(page).to have_content("Your email or password was incorrect!")

      visit login_path

      fill_in 'Email', with: @user.email
      fill_in 'Password', with: "newpassword"
      click_button 'Log In'

      expect(current_path).to eq(profile_path)
    end

    it "I must use a unique email address" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit '/profile/edit'

      fill_in "Email", with: @admin.email
      click_button "Update Profile"

      expect(page).to have_content("email: [\"has already been taken\"]")
      expect(page).to have_button "Update Profile"
    end

    it "I can add a new Address, choose whether to assign it as my default, then change my default through the address index" do
      visit login_path

      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log In'

      visit profile_path

      expect(@user.address.nickname).to eq('home')

      within "#current-address" do
        expect(page).to have_content("Current Address: Home")
        expect(page).to have_content(@address_1.address)
        expect(page).to have_content("#{@address_1.city}, #{@address_1.state} #{@address_1.zip}")
        expect(page).to have_link("All Addresses")
        expect(page).to have_link("Add New Address")
        expect(page).to have_link("Edit Current Address")
        expect(page).to have_link("Delete Current Address")
        click_link 'Add New Address'
      end

      expect(current_path).to eq('/profile/addresses/new')

      address = '124 new str'
      city = 'new town'
      state = 'NY'
      zip = '12034'
      nickname = 'gf'

      fill_in "Address", with: address
      fill_in "City", with: city
      fill_in "State", with: state
      fill_in "Zip", with: zip
      fill_in "Nickname", with: nickname
      select("Yes", from: 'default_address')

      click_button 'Create Address'

      expect(current_path).to eq(profile_path)
      expect(@user.address.nickname).to eq('gf')
      @address_3 = Address.last

      within "#current-address" do
        expect(page).to have_content("Current Address: Gf")
        expect(page).to have_content(address)
        expect(page).to have_content(city)
        expect(page).to have_content(state)
        expect(page).to have_content(zip)
        click_link 'All Addresses'
      end

      expect(current_path).to eq("/profile/addresses")

      within "#address-#{@address_1.id}" do
        expect(page).to have_content('123 Main St')
        expect(page).to have_content('Denver')
        expect(page).to have_content('CO')
        expect(page).to have_content('80218')
        expect(page).to have_content('Home')
        expect(page).to have_link('Set as Default Address')
        expect(page).to have_link('Delete Address')
      end

      within "#address-#{@address_3.id}" do
        expect(page).to_not have_link('Set as Default Address')
        expect(page).to have_content("Currently used as default address.")
        expect(page).to have_content(@address_3.address)
        expect(page).to have_content(@address_3.city)
        expect(page).to have_content(@address_3.state)
        expect(page).to have_content(@address_3.zip)
        expect(page).to have_content(@address_3.nickname)
      end

      within "#address-#{@address_2.id}" do
        expect(page).to have_content(@address_2.address)
        expect(page).to have_content(@address_2.city)
        expect(page).to have_content(@address_2.state)
        expect(page).to have_content(@address_2.zip)
        expect(page).to have_content(@address_2.nickname)
        expect(page).to have_link('Set as Default Address')
        click_link 'Set as Default Address'
      end

      expect(current_path).to eq(profile_path)
      expect(page).to have_content("You have set '#{@address_2.nickname}' as your default address")

      within "#current-address" do
        expect(page).to have_content("Current Address: Work")
        expect(page).to have_content(@address_2.address)
        expect(page).to have_content(@address_2.city)
        expect(page).to have_content(@address_2.state)
        expect(page).to have_content(@address_2.zip)
        click_link 'Add New Address'
      end

      address = '123 Bad st'
      city = 'Badville'
      state = 'NY'
      zip = '12034'
      nickname = 'dealer'

      fill_in "Address", with: address
      fill_in "City", with: city
      fill_in "State", with: state
      fill_in "Zip", with: zip
      fill_in "Nickname", with: nickname
      select("No", from: 'default_address')

      click_button 'Create Address'

      @address_4 = Address.last
      expect(current_path).to eq(profile_path)
      expect(@user.address.nickname).to eq('Work')

      within "#current-address" do
        expect(page).to have_content("Current Address: Work")
        expect(page).to have_content(@address_2.address)
        expect(page).to have_content(@address_2.city)
        expect(page).to have_content(@address_2.state)
        expect(page).to have_content(@address_2.zip)
      end
    end

    it "I can delete address from my profile page and select a new one" do
      address_3 = @user.addresses.create!(address: '123 Bad st', city: 'Badville', state: 'NY', zip: 12034, nickname: 'dealer')

      visit login_path
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log In'
      visit profile_path

      expect(@user.address.nickname).to eq('home')

      within "#current-address" do
        expect(page).to have_content("Current Address: Home")
        expect(page).to have_content(@user.email)
        expect(page).to have_content(@user.name)
        expect(page).to have_content(@address_1.address)
        expect(page).to have_content(@address_1.city)
        expect(page).to have_content(@address_1.state)
        expect(page).to have_content(@address_1.zip)
        expect(page).to have_link("Delete Current Address")
        click_link 'Delete Current Address'
      end

      expect(current_path).to eq("/profile/addresses")
      expect(page).to have_content("You have deleted your Home address.")
      expect(page).to have_content("You should choose or create a new default address")
      expect(page).to have_link('Back to my Profile')
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
    end
      #Tests that the only remaining address will be automatically set to default
    it "Automatically sets my only remaining address to default when I delete my current address" do
      visit login_path
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log In'
      visit profile_path

      expect(@user.address.nickname).to eq('home')

      within "#current-address" do
        expect(page).to have_content("Current Address: Home")
        expect(page).to have_content(@user.email)
        expect(page).to have_content(@address_1.address)
        expect(page).to have_content("#{@address_1.city}, #{@address_1.state} #{@address_1.zip}")
        expect(page).to have_link("Delete Current Address")
        click_link 'Delete Current Address'
      end

      expect(current_path).to eq(profile_path)
      expect(page).to have_content("#{@address_2} has been set to your default address")
      expect(page).to have_content("You have deleted your Home address.")

      within "#current-address" do
        expect(page).to have_content("Current Address: Work")
        expect(page).to have_content(@address_2.address)
        expect(page).to have_content(@address_2.city)
        expect(page).to have_content(@address_2.state)
        expect(page).to have_content(@address_2.zip)
      end
    end

    it "Wont let me delete addresses that have been used in shipped orders" do
      megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      ogre = megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      user = User.create!(name: 'Megan', email: 'megan_1example.com', password: 'securepassword')
      address_1 = user.addresses.create!(address: '123 Bad st', city: 'Badville', state: 'NY', zip: 12034)
      expect(user.address).to eq(address_1)
      address_2 = user.addresses.create!(address: '456 Main st', city: 'Dallas', state: 'TX', zip: 75402, nickname: 'Work')

      order_1 = user.orders.create!(address_id: address_1, status: 'shipped')
      order_1.order_items.create!(item: ogre, price: ogre.price, quantity: 2, status: 2)

      visit login_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Log In'
      visit profile_path

      within "#current-address" do
        expect(page).to have_content("Current Address: Home")
        expect(page).to have_content(address_1.address)
        expect(page).to have_content(address_1.city)
        expect(page).to have_content(address_1.state)
        expect(page).to have_content(address_1.zip)
        expect(page).to_not have_link('Delete Current Address')
        click_link 'All Addresses'
      end

      expect(current_path).to eq("/profile/addresses")

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

      expect(current_path).to eq("/profile/addresses")
      expect(page).to have_content("You have deleted your Work address.")
    end
  end
end
