require 'rails_helper'

RSpec.describe 'Merchant Discount New Page' do
  describe 'As a Merchant employee' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)

      @giant = @merchant_1.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: false, inventory: 3)
    end

    it 'I can create a new discount' do
      name = '50% off 15 giants'
      percentage = 50
      minimum_quantity = 15
      item_name = 'Giant'

      visit "/merchant/discounts/new"

      fill_in 'Name', with: name
      fill_in 'Percentage', with: percentage
      fill_in :minimum_quantity, with: minimum_quantity
      fill_in 'Item Name', with: item_name
      click_button 'Create Discount'

      expect(current_path).to eq("/merchant/discounts")
      expect(page).to have_link(name)
    end

    it 'I cannot create a discount with an incomplete form' do
      name = '50% off 15 giants'
      item_name = 'Giant'

      visit "/merchant/discounts/new"

      fill_in 'Name', with: name
      fill_in 'Item Name', with: item_name
      click_button 'Create Discount'

      expect(page).to have_content("percentage: [\"can't be blank\"]")
      expect(page).to have_content("minimum_quantity: [\"can't be blank\"]")
      expect(page).to have_button('Create Discount')
    end

    it "I cannot create a discount if the item doesn't exist" do
    end
  end
end
