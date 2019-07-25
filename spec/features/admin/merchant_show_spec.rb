require 'rails_helper'

RSpec.describe "Admin Merchant Show Page" do
  describe "As an Admin" do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @admin = User.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: :admin)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
    end
    it 'I can link to an admin merchant show from merchants index' do
      visit '/merchants'

      click_link @megan.name

      expect(current_path).to eq("/admin/merchants/#{@megan.id}")
    end
  end
end
