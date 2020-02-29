require 'rails_helper'

describe 'New Merchant Discount' do
  describe 'As a Merchant' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ben = megan.users.create(name: "Ben Fox", address: "2475 Field St", city: "Lakewood", state: "CO", zip: "80215", email: "benfox1216@gmail.com", password: "password")
      @item_1 = megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @item_2 = megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'I can click a link to a new discount form page' do
      visit "/merchant/discounts"
      click_link 'New Discount'

      expect(current_path).to eq("/merchant/discounts/new")
    end
    
    it 'I can create a discount for a merchants item' do
      amount = 5
      num_items = 20

      visit "/merchant/discounts/new"

      fill_in 'Percent Discount', with: amount
      fill_in 'Minimum Items', with: num_items
      
      
      click_button 'Create Discount'

      expect(current_path).to eq("/merchant/discounts")
      expect(page).to have_link(name)
    end

    it 'I cannot create a discount for a merchant with an incomplete form' do
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
