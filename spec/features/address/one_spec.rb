require 'rails_helper'

RSpec.describe "Address Saved in Registration" do
  describe "As a new user" do
    it "When a user registers they will still provide an address this will
    become their first address entry in the database, nicknamed 'home'" do

    visit root_path
    click_link 'Register'
    expect(current_path).to eq(registration_path)

    fill_in 'Name', with: 'Megan'
    fill_in 'Address', with: '123 Main St'
    fill_in 'City', with: 'Denver'
    fill_in 'State', with: 'CO'
    fill_in 'Zip', with: '80218'
    fill_in 'Email', with: 'megan@example.com'
    fill_in 'Password', with: 'securepassword'
    fill_in 'Password confirmation', with: 'securepassword'
    click_button 'Register'
    expect(current_path).to eq(profile_path)

    address = Address.last

    expect(page).to have_content(address.address)
    expect(page).to have_content(address.city)
    expect(page).to have_content(address.state)
    expect(page).to have_content(address.zip)
    end
  end
end
