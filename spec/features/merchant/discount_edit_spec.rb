require 'rails_helper'

RSpec.describe 'Merchant Update Discounts' do
  describe 'As a Merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @discount = @merchant_1.discounts.create(name: '7 Percent', percentage: 0.07, limit: 14)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'A merchant can update their own discount' do

      visit '/merchant/discounts'

      within "#discount-#{@discount.id}" do
        click_link ("Update")
      end

      expect(current_path).to eq("/merchant/discounts/#{@discount.id}/edit")

      expect(find_field("Name").value).to eq "7 Percent"
      expect(find_field('Percentage').value).to eq "0.07"
      expect(find_field('Limit').value).to eq "14"

      fill_in :name, with: "7 %"

      click_button "Update Discount"
      expect(current_path).to eq('/merchant/discounts')

      within "#discount-#{@discount.id}" do
        expect(page).to have_content("#{@discount.name} Discount")
        expect(@discount.name).to eq("7 %")
      end
    end

    it "Will not update a Discount without required information" do
      visit '/merchant/discounts'

      click_link "Create Discount"

      fill_in "Name", with: ""
      fill_in "Percentage", with: nil
      fill_in "Limit", with: 12

      click_button "Create Discount"
      expect(current_path).to eq('/merchant/discounts')
      expect(page).to have_content("Name can't be blank and Percentage can't be blank")
    end
  end
end
