require 'rails_helper'

RSpec.describe 'New Review Creation' do
  describe 'As a registered user' do
    before :each do
        @user = User.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
        @office_address = @user.addresses.create(address:'123 North St', city: 'Missoula', state: 'MT', zip: 12345, nickname:1)
        @other_address  = @user.addresses.create(address:'123 South St', city: 'Houston', state: 'TX', zip: 77007, nickname: 2)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
        visit profile_path
        click_link "My Addresses", user_addresses_path
      end

    describe "When I go to my Address Index page" do
      it "I see all of the addresxses associated with my account" do
        within "#address-#{@office_address}" do
          expect(page).to have_content(@office_address.address)
          expect(page).to have_content(@office_address.city)
          expect(page).to have_content(@office_address.state)
          expect(page).to have_content(@office_address.zip)
          expect(page).to have_content(@office_address.nickname)
        end

        within "#address-#{@other_address}" do
          expect(page).to have_content(@other_address.address) 
          expect(page).to have_content(@other_address.city)
          expect(page).to have_content(@other_address.state)
          expect(page).to have_content(@other_address.zip)
          expect(page).to have_content(@other_address.nickname)
        end
      end
    end
  end
end
