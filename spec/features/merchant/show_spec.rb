require 'rails_helper'

RSpec.describe 'Merchant Show Page' do
  describe 'As a visitor' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
    end

    it 'I see merchant name and address' do
      visit "/merchants/#{@megan.id}"

      expect(page).to have_content(@megan.name)

      within '.address' do
        expect(page).to have_content(@megan.address)
        expect(page).to have_content("#{@megan.city} #{@megan.state} #{@megan.zip}")
      end
    end

    it 'I see a link to this merchants items' do
      visit "/merchants/#{@megan.id}"

      click_link "Items"

      
    end
  end
end
