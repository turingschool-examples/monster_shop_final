require 'rails_helper'
include ActionView::Helpers::NumberHelper

describe 'As an employee of a merchant' do
  describe "When I delete an existing discount" do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @user_1 = @merchant_1.users.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @discount_1 = @merchant_1.discounts.create!(rate: 5, quantity: 10)
      @discount_2 = @merchant_1.discounts.create!(rate: 10, quantity: 20)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
    end

    xit "I can delete discount from index page" do
      visit '/merchant/discounts'

      within "#discount-#{@discount_2.id}" do
        click_link("Delete Discount")
      end

      expect(current_path).to eq("/merchant/discounts")
      visit "/merchant/discounts"

      expect(page).to have_content(@discount_1.rate)
      expect(page).to_not have_content(@discount_2.rate)
    end

    xit "I can delete discount from show page" do
      visit "/merchant/discounts/#{@discount_2.id}"

      click_link("Delete Discount")

      expect(current_path).to eq("/merchant/discounts")
      visit "/merchant/discounts"
      expect(page).to have_content(@discount_1.rate)
      expect(page).to_not have_content(@discount_2.rate)
    end
  end
end
