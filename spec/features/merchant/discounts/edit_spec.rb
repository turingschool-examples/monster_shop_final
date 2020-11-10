require 'rails_helper'

describe 'As an employee of a merchant' do
  describe "When I edit an existing discount" do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @user_1 = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @discount_1 = @merchant_1.discounts.create!(rate: 5, quantity: 10)
      @discount_2 = @merchant_1.discounts.create!(rate: 10, quantity: 20)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
    end

    it "I can edit a discount" do
      visit "/merchant/discounts/#{@discount_1.id}/edit"

      fill_in :rate, with: 5.5

      click_on "Update Discount"

      expect(current_path).to eq("/merchant/discounts")

      within "#discount-#{@discount_1.id}" do
        expect(page).to have_content("5.5%")
        expect(page).to_not have_content("5.0%")
      end
    end
    it "I get an error message if I fill out form incorrectly" do
      visit "/merchant/discounts/#{@discount_1.id}/edit"
      fill_in :rate, with: 500
      fill_in :quantity, with: -100

      click_on "Update Discount"
      expect(page).to have_content("rate: [\"must be less than or equal to 100\"]")
      expect(page).to have_content("quantity: [\"must be greater than 0\"]")
    end
  end
end
