require 'rails_helper'

RSpec.describe 'Merchant Discount Edit Discount Page' do
  describe 'As a Merchant employee' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)

      @giant = @merchant_1.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: false, inventory: 3)

      @giant_twenty_percent = Discount.create!(name: '20% off 5 giants', percentage: 20, minimum_quantity: 5, item_id: @giant.id)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it "I can edit the discount's info" do
      name = '50% off 15 big giants'
      percentage = 50
      minimum_quantity = 15
      item_name = 'Big Giant'

      visit "/merchant/discounts/#{@giant_twenty_percent.id}/edit"

      fill_in 'Name', with: name
      fill_in 'Percentage', with: percentage
      fill_in :minimum_quantity, with: minimum_quantity
      fill_in 'Item Name', with: item_name
      click_button 'Update Discount'

      expect(current_path).to eq("/merchant/discounts/#{@giant_twenty_percent.id}")
      expect(page).to have_content(name)
      expect(page).to have_content(percentage)
      expect(page).to have_content(minimum_quantity)
    end
  end
end
