require 'rails_helper'

RSpec.describe 'User Login and Log Out' do
  describe 'A registered user can log in' do
    describe 'As a default user' do
      before :each do
        @user = User.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      end

      it 'with correct credentials' do
        visit login_path

        fill_in 'Email', with: @user.email
        fill_in 'Password', with: @user.password
        click_button 'Log In'

        expect(current_path).to eq(profile_dashboard_path)
        expect(page).to have_content("Logged in as #{@user.name}")
      end

      it 'users already logged in will be redirected' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

        visit login_path

        expect(current_path).to eq(profile_dashboard_path)
        expect(page).to have_content('You are already logged in!')
      end
    end

    describe 'As a merchant user' do
      before :each do
        @merchant = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
        @m_user = @merchant.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      end

      it 'with correct credentials' do
        visit login_path

        fill_in 'Email', with: @m_user.email
        fill_in 'Password', with: @m_user.password
        click_button 'Log In'

        expect(current_path).to eq(merchant_dashboard_path)
        expect(page).to have_content("Logged in as #{@m_user.name}")
      end

      it 'users already logged in will be redirected' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)

        visit login_path

        expect(current_path).to eq(merchant_dashboard_path)
        expect(page).to have_content('You are already logged in!')
      end
    end

    describe 'As admin user' do
      before :each do
        @admin = User.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: :admin)
      end

      it 'with correct credentials' do
        visit login_path

        fill_in 'Email', with: @admin.email
        fill_in 'Password', with: @admin.password
        click_button 'Log In'

        expect(current_path).to eq(admin_dashboard_path)
        expect(page).to have_content("Logged in as #{@admin.name}")
      end

      it 'users already logged in will be redirected' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

        visit login_path

        expect(current_path).to eq(admin_dashboard_path)
        expect(page).to have_content('You are already logged in!')
      end
    end
  end

  describe 'A registered user can not log in with bad credentials' do
    before :each do
      @user = User.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
    end

    it 'incorrect email' do
      visit login_path

      fill_in 'Email', with: 'bad@email.com'
      fill_in 'Password', with: @user.password
      click_button 'Log In'

      expect(page).to have_content('Your email or password was incorrect!')
      expect(page).to have_button('Log In')
    end

    it 'incorrect password' do
      visit login_path

      fill_in 'Email', with: @user.email
      fill_in 'Password', with: 'bad password'
      click_button 'Log In'

      expect(page).to have_content('Your email or password was incorrect!')
      expect(page).to have_button('Log In')
    end
  end

  describe 'A logged in user can log out' do
    before :each do
      @user = User.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
    end

    it 'I visit the log out path' do
      visit login_path

      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log In'

      click_link 'Log Out'

      expect(current_path).to eq(root_path)
      expect(page).to_not have_content("Logged in as #{@user.name}")
      expect(page).to have_content('You have been logged out!')
    end

    it 'I log out and my cart is cleared' do
      megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      ogre = megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )

      visit login_path

      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log In'

      visit item_path(ogre)

      click_button 'Add to Cart'

      expect(page).to have_link('Cart: 1')

      click_link 'Log Out'

      expect(page).to have_link('Cart: 0')
    end
  end
end
