require 'rails_helper'

describe 'New Merchant Discount' do
  describe 'As a Merchant' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      hippo = brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      
      @ben = @megan.users.create(name: "Ben Fox", address: "2475 Field St", city: "Lakewood", state: "CO", zip: "80215", email: "benfox1216@gmail.com", password: "password")
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@ben)
    end

    it 'I can click a link to a new discount form page' do
      visit "/merchant/discounts"
      click_link 'New Discount'

      expect(current_path).to eq("/merchant/discounts/new")
    end
    
    it 'I can create multiple discounts for a multiple items' do
      visit "/merchant/discounts/new"

      fill_in :amount, with: 5
      fill_in :num_items, with: 20
      expect(page).to have_content('Giant')
      expect(page).to_not have_content('Hippo')
      check('Ogre', allow_label_click: true)
      
      click_button 'Create Discount'
      expect(current_path).to eq("/merchant/discounts")
      expect(page).to have_content("Discounted Items")
      
      click_link 'New Discount'

      fill_in :amount, with: 10
      fill_in :num_items, with: 30
      check('Ogre', allow_label_click: true)
      check('Giant', allow_label_click: true)
      
      click_button 'Create Discount'

      within "#item-#{@ogre.id}" do
        expect(page).to have_content("Ogre")
        expect(page).to have_content("5% discount on 20 or more items")
        expect(page).to have_content("10% discount on 30 or more items")
      end
      
      within "#item-#{@giant.id}" do
        expect(page).to have_content("Giant")
        expect(page).to have_content("5% discount on 20 or more items")
        expect(page).to_not have_content("10% discount on 30 or more items")
      end
    end

    it 'I cannot create a discount with an incomplete form' do
      # name = 'Ogre'
      #
      # visit "/merchant/items/new"
      #
      # fill_in 'Name', with: name
      # click_button 'Create Item'
      #
      # expect(page).to have_content("description: [\"can't be blank\"]")
      # expect(page).to have_content("price: [\"can't be blank\"]")
      # expect(page).to have_content("image: [\"can't be blank\"]")
      # expect(page).to have_content("inventory: [\"can't be blank\"]")
      # expect(page).to have_button('Create Item')
    end
  end
end
