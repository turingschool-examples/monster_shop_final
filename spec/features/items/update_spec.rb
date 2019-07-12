require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Update Item Page' do
  describe 'As a Visitor' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
    end

    it 'I can click a link to get to an item edit page' do
      visit "/items/#{@ogre.id}"

      click_link 'Update Item'

      expect(current_path).to eq("/items/#{@ogre.id}/edit")
    end

    it 'I can edit the items information' do
      name = 'Giant'
      description = "I'm a Giant!"
      price = 25
      image = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw'
      inventory = 12

      visit "/items/#{@ogre.id}/edit"

      fill_in 'Name', with: name
      fill_in 'Description', with: description
      fill_in 'Price', with: price
      fill_in 'Image', with: image
      fill_in 'Inventory', with: inventory
      click_button 'Update Item'

      expect(current_path).to eq("/items/#{@ogre.id}")
      expect(page).to have_content(name)
      expect(page).to have_content(description)
      expect(page).to have_content("Price: #{number_to_currency(price)}")
      expect(page).to have_content("Active")
      expect(page).to have_content("Inventory: #{inventory}")
    end

    it 'I can not edit the item with an incomplete form' do
      name = 'Giant'

      visit "/items/#{@ogre.id}/edit"

      fill_in 'Name', with: name
      click_button 'Update Item'

      expect(page).to have_content("description: [\"can't be blank\"]")
      expect(page).to have_content("price: [\"can't be blank\"]")
      expect(page).to have_content("image: [\"can't be blank\"]")
      expect(page).to have_content("inventory: [\"can't be blank\"]")
      expect(page).to have_button('Update Item')
    end
  end
end
