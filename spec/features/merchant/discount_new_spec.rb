require 'rails_helper'

RSpec.describe 'Merchant New Discount' do
  describe 'As a Merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'A merchant can create their own discount' do
      visit '/merchant/discounts'

      expect(page).to have_link("Create Discount")
      click_link "Create Discount"

      expect(current_path).to eq('/merchant/discounts/new')

      fill_in "Name", with: "12 Percent"
      fill_in "Percentage", with: 0.12
      fill_in "Limit", with: 15
      click_button "Create Discount"

      expect(current_path).to eq('/merchant/discounts')

      new_discount = Discount.last

      within "#discount-#{new_discount.id}" do
        expect(page).to have_content("#{new_discount.name} Discount")
        expect(page).to have_content("Limit: #{new_discount.limit}")
      end
    end

    it "Will not create a new Discount without required information" do
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
