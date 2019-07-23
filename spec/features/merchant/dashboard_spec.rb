require 'rails_helper'

RSpec.describe 'Merchant Dashboard' do
  describe 'As an employee of a merchant' do
    before :each do
      @merchant = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'I can see my merchants information on the merchant dashboard' do
      visit '/merchant'

      expect(page).to have_link(@merchant.name)
      expect(page).to have_content(@merchant.address)
      expect(page).to have_content("#{@merchant.city} #{@merchant.state} #{@merchant.zip}")
    end

    it 'I do not have a link to edit the merchant information' do
      visit '/merchant'

      expect(page).to_not have_link('Edit')
    end
  end
end
