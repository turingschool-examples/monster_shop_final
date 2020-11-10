require 'rails_helper'

RSpec.describe 'Merchant Discount Show Page' do
  describe 'As a Merchant employee' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')

      @ogre = @merchant_1.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @merchant_1.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: false, inventory: 3 )

      @ogre_twenty_percent = Discount.create!(name: '20% off 5 ogres', percentage: 20, minimum_quantity: 5, item_id: @ogre.id)
      @ogre_thirty_percent = Discount.create!(name: '30% off 10 ogres', percentage: 30, minimum_quantity: 10, item_id: @ogre.id)
      @giant_twenty_percent = Discount.create!(name: '20% off 5 giants', percentage: 20, minimum_quantity: 5, item_id: @giant.id)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it "I see a discount's name, percentage, and minimum_quantity" do
      visit "/merchant/discounts/#{@giant_twenty_percent.id}"

      expect(page).to have_content(@giant_twenty_percent.name)
      expect(page).to have_content("Discounted percentage: #{@giant_twenty_percent.percentage}")
      expect(page).to have_content("Minimum number of items to qualify: #{@giant_twenty_percent.minimum_quantity}")

      expect(page).to_not have_content(@ogre_thirty_percent.name)
      expect(page).to_not have_content(@ogre_thirty_percent.percentage)
      expect(page).to_not have_content(@ogre_thirty_percent.minimum_quantity)
    end

    it "I can click a link to an edit discount form page" do
      visit "/merchant/discounts/#{@giant_twenty_percent.id}"

      click_link 'Update Discount'

      expect(current_path).to eq("/merchant/discounts/#{@giant_twenty_percent.id}/edit")
    end

    it "I can click a link to delete discount" do
      visit "/merchant/discounts/#{@giant_twenty_percent.id}"

      click_link 'Delete Discount'

      expect(current_path).to eq("/merchant/discounts")
      expect(page).to_not have_content(@giant_twenty_percent.name)
    end
  end
end
