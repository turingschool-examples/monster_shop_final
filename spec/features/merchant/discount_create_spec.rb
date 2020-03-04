require 'rails_helper'

RSpec.describe 'Discount Creation' do
  describe 'As an employee of a merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @ogre = @merchant_1.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 80 )
      @giant = @merchant_1.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 80 )
      @hippo = @merchant_2.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 80 )
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it "can create a new discount" do
      visit "/merchant/discounts"

      click_link "Create New Discount"

      expect(current_path).to eq("/merchant/discounts/new")

      fill_in 'percent_off', with: "25"
      fill_in 'quantity_threshold', with: "50"
      fill_in 'status', with: "active"

      click_on "Save Discount"

      discount = Discount.last

      expect(current_path).to eq("/merchant/discounts")

      expect(page).to have_content("Percent off: 25")
      expect(page).to have_content("Quantity Threshold: 50")
      expect(page).to have_content("Status: active")

      visit "/merchant/discounts/#{discount.id}"

      expect(page).to have_content(discount.id)
      expect(page).to have_content("Percent off: 25")
      expect(page).to have_content("Amount needed to trigger discount: 50")
      expect(page).to have_content("Status: active")
end

    it "can't create with incomplete fields" do
      visit "/merchant/discounts"

      click_link "Create New Discount"

      expect(current_path).to eq("/merchant/discounts/new")

      fill_in 'percent_off', with: "25"
      fill_in 'quantity_threshold', with: ""
      fill_in 'status', with: "active"

      click_on "Save Discount"

      expect(current_path).to eq("/merchant/discounts/new")
    end
  end
end
