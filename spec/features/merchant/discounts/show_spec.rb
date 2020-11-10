require 'rails_helper'

describe 'As an employee of a merchant' do
  describe "When I visit a discount's show page" do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @user_1 = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @discount_1 = @merchant_1.discounts.create!(rate: 5, quantity: 10)
      @discount_2 = @merchant_1.discounts.create!(rate: 10, quantity: 20)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
    end

    it "I see the discount rate, quantity and the merchant's name" do
      visit "/merchant/discounts/#{@discount_1.id}"

      expect(page).to have_content("Discount ID: #{@discount_1.id}")
      expect(page).to have_content("Percentage Off: #{@discount_1.rate}%")
      expect(page).to have_content("Minimum Quantity: #{@discount_1.quantity}")
      expect(page).to have_content(@discount_1.merchant.name)

      expect(page).to_not have_content(@discount_2.id)
    end

    it "I see a link to edit the discount and can click it to get to the edit page" do
      visit "/merchant/discounts/#{@discount_1.id}"

      expect(page).to have_link("Edit Discount")

      click_link("Edit Discount")
      expect(current_path).to eq("/merchant/discounts/#{@discount_1.id}/edit")
    end

    it "I see a link to delete the discount" do
      visit "/merchant/discounts/#{@discount_1.id}"

      expect(page).to have_link("Delete Discount")

      click_link("Delete Discount")
      expect(current_path).to eq("/merchant/discounts")
    end
  end
end
