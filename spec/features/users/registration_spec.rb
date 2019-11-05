require 'rails_helper'

RSpec.describe 'User Registration' do
  describe 'As a Visitor' do
    it 'I see a link to register as a user' do
      visit root_path

      click_link 'Register'

      expect(current_path).to eq(registration_path)
    end

    it 'I can register as a user' do
      visit registration_path

      fill_in 'address[street_address]', with: '123 Main St'
      fill_in 'address[city]', with: 'Denver'
      fill_in 'address[state]', with: 'CO'
      fill_in 'address[zip]', with: '80218'
      fill_in 'address[nickname]', with: 'home'
      fill_in 'Name', with: 'Megan'
      fill_in 'Email', with: 'megan@example.com'
      fill_in 'Password', with: 'securepassword'
      fill_in 'Password confirmation', with: 'securepassword'
      click_button 'Register'

      expect(current_path).to eq(profile_path)
      expect(page).to have_content('Welcome, Megan!')
    end

    describe 'I can not register as a user if' do
      it 'I do not complete the registration form' do
        visit registration_path

        fill_in 'Name', with: 'Megan'
        click_button 'Register'

        expect(page).to have_button('Register')
        expect(page).to have_content("Password can't be blank, street address can't be blank, city can't be blank, state can't be blank, zip can't be blank, nickname can't be blank, and Email can't be blank")
      end

      it 'I use a non-unique email' do
        user = User.create(name: 'Megan', email: 'megan@example.com', password: 'securepassword')
        user_address = user.addresses.create(street_address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)

        visit registration_path

        fill_in 'Name', with: user.name
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        fill_in 'Password confirmation', with: user.password
        fill_in 'address[street_address]', with: user_address.street_address
        fill_in 'address[city]', with: user_address.city
        fill_in 'address[state]', with: user_address.state
        fill_in 'address[zip]', with: user_address.zip
        fill_in 'address[nickname]', with: user_address.nickname

        click_button 'Register'

        expect(page).to have_button('Register')
        expect(page).to have_content("Email has already been taken")
      end
    end
  end
end
