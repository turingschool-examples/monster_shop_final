require 'rails_helper'

describe 'As an employee of a merchant' do
  describe "When I visit the form for a new discount" do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @user_1 = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @discount_1 = @merchant_1.discounts.create!(rate: 5, quantity: 10)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
    end
    it "I can fill in a form for a new discount" do
      visit new_merchant_discount_path

      fill_in :rate, with: 15.5
      fill_in :quantity, with: 35

      click_on("Submit")

      new_discount = Discount.last

      expect(current_path).to eq(merchant_discounts_path)

      within "#discount-#{new_discount.id}" do
        expect(page).to have_content(new_discount.rate)
        expect(page).to have_content(new_discount.quantity)
      end
    end

    describe "I get an error message" do
      it "When I don't fully fill out a form" do
        visit new_merchant_discount_path

        click_on("Submit")
        expect(page).to have_content("rate: [\"can't be blank\", \"is not a number\"]")
        expect(page).to have_content("quantity: [\"can't be blank\", \"is not a number\"]")
      end

      it "When I give negative numbers" do
        visit new_merchant_discount_path
        fill_in :rate, with: -19
        fill_in :quantity, with: -35

        click_on("Submit")
        expect(page).to have_content("rate: [\"must be greater than 0\"]")
        expect(page).to have_content("quantity: [\"must be greater than 0\"]")
      end
      it "When I go outside the accepted values" do
        visit new_merchant_discount_path
        fill_in :rate, with: 190

        click_on("Submit")
        expect(page).to have_content("rate: [\"must be less than or equal to 100\"]")
      end
    end
  end
end
