require 'rails_helper'

RSpec.describe "User Profile Path" do
  describe "As a registered user" do
    before :each do
      @user = User.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end
    
    it "I can view my profile page" do
      visit profile_path

      expect(page).to have_content(@user.name)
      expect(page).to have_content(@user.address)
      expect(page).to have_content("#{@user.city} #{@user.state} #{@user.zip}")
      expect(page).to_not have_content(@user.password)
      expect(page).to have_link('Edit')
    end
  end
end
