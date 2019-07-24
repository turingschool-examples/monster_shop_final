require 'rails_helper'

RSpec.describe 'Merchant Index Page' do
  describe 'As a visitor' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, enabled: true)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218, enabled: false)
    end

    it 'I see a list of all merchants' do
      visit '/merchants'

      within "#merchant-#{@megan.id}" do
        expect(page).to have_link(@megan.name)
        expect(page).to_not have_button('Disable')
      end

      within "#merchant-#{@brian.id}" do
        expect(page).to have_link(@brian.name)
        expect(page).to_not have_button('Enable')
      end
    end

    it 'I can click a link to get to a merchants show page' do
      visit '/merchants'

      click_link @megan.name

      expect(current_path).to eq("/merchants/#{@megan.id}")
    end
  end

  describe 'As an Admin' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, enabled: true)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218, enabled: false)
      @admin = User.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: :admin)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
    end

    it 'I can disable a merchant' do
      visit '/merchants'

      within "#merchant-#{@megan.id}" do
        click_button('Disable')
      end

      expect(current_path).to eq(merchants_path)
      expect(page).to have_content("#{@megan.name} has been disabled")
      visit '/merchants'
      within "#merchant-#{@megan.id}" do
        expect(page).to have_button('Enable')
      end
    end

    it 'I can enable a merchant' do
      visit '/merchants'

      within "#merchant-#{@brian.id}" do
        click_button('Enable')
      end

      expect(current_path).to eq(merchants_path)
      expect(page).to have_content("#{@brian.name} has been enabled")
      visit '/merchants'
      within "#merchant-#{@brian.id}" do
        expect(page).to have_button('Disable')
      end
    end
  end
end
