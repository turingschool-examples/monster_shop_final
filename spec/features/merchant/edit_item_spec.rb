require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Update Item Page' do
  describe 'As a Visitor' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @merchant_1.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @m_user = @merchant_1.users.create(name: 'Megan', email: 'megan@example.com', password: 'securepassword')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'I can click a link to get to an item edit page' do
      visit "/merchant/items"

      click_link 'Update Item'

      expect(current_path).to eq("/merchant/items/#{@ogre.id}/edit")
    end

    it 'I can edit the items information' do
      name = 'Giant'
      description = "I'm a Giant!"
      price = 25
      image = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw'
      inventory = 12

      visit "merchant/items/#{@ogre.id}/edit"

      fill_in 'Name', with: name
      fill_in 'Description', with: description
      fill_in 'Price', with: price
      fill_in 'Image', with: image
      fill_in 'Inventory', with: inventory
      click_button 'Update Item'

      expect(current_path).to eq("/merchant/items")
      expect(page).to have_content(name)
      expect(page).to have_content(description)
      expect(page).to have_content("Price: #{number_to_currency(price)}")
      expect(page).to have_content("Active")
      expect(page).to have_content("Inventory: #{inventory}")
    end

    it 'I can not edit the item with an incomplete form' do
      name = 'Giant'

      visit "merchant/items/#{@ogre.id}/edit"

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
