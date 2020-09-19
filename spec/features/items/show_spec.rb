require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Item Show Page' do
  describe 'As a Visitor' do
    before :each do
      @morgan = Merchant.create!(name: 'Morgans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @morgan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @morgan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
    end

    it "I can see the items details" do
      visit "/items/#{@ogre.id}"

      expect(page).to have_content(@ogre.name)
      expect(page).to have_content(@ogre.description)
      expect(page).to have_content("Price: #{number_to_currency(@ogre.price)}")
      expect(page).to have_content("Active")
      expect(page).to have_content("Inventory: #{@ogre.inventory}")
      expect(page).to have_content("Sold by: #{@morgan.name}")
      expect(page).to have_link(@morgan.name)
    end
  end
end
