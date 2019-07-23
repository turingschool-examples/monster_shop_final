require 'rails_helper'

RSpec.describe 'Merchant Index Page' do
  describe 'As a visitor' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
    end

    it 'I see a list of all merchants' do
      visit '/merchants'

      within "#merchant-#{@megan.id}" do
        expect(page).to have_link(@megan.name)
      end

      within "#merchant-#{@brian.id}" do
        expect(page).to have_link(@brian.name)
      end
    end

    it 'I can click a link to get to a merchants show page' do
      visit '/merchants'

      click_link @megan.name

      expect(current_path).to eq("/merchants/#{@megan.id}")
    end
  end
end
