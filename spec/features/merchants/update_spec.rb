require 'rails_helper'

RSpec.describe 'Existing Merchant Update' do
  describe 'As a Visitor' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
    end

    it 'I can link to an edit merchant page from merchant show page' do
      visit "/merchants/#{@megan.id}"

      click_button 'Edit'

      expect(current_path).to eq("/merchants/#{@megan.id}/edit")
    end

    it 'I can use the edit merchant form to update the merchant information' do
      visit "/merchants/#{@megan.id}/edit"

      name = 'Megans Monsters'
      address = '321 Main St'
      city = "Denver"
      state = "CO"
      zip = 80218

      fill_in 'Name', with: name
      fill_in 'Address', with: address
      fill_in 'City', with: city
      fill_in 'State', with: state
      fill_in 'Zip', with: zip

      click_button 'Update Merchant'

      expect(current_path).to eq("/merchants/#{@megan.id}")
      expect(page).to have_content(name)
      expect(page).to_not have_content(@megan.name)

      within '.address' do
        expect(page).to have_content(address)
        expect(page).to have_content("#{city} #{state} #{zip}")
      end
    end


    it 'I can not edit a merchant with an incomplete form' do
      visit "/merchants/#{@megan.id}/edit"

      name = 'Megans Marmalades'

      fill_in 'Name', with: name

      click_button 'Update Merchant'

      expect(page).to have_content("address: [\"can't be blank\"]")
      expect(page).to have_content("city: [\"can't be blank\"]")
      expect(page).to have_content("state: [\"can't be blank\"]")
      expect(page).to have_content("zip: [\"can't be blank\"]")
      expect(page).to have_button('Update Merchant')
    end
  end
end
