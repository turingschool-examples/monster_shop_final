require 'rails_helper'

RSpec.describe "As a merchant employee", type: :feature do

  describe 'when I visit my merchant dashboard' do

    before(:each) do
      @bike_shop = Merchant.create!(name: 'Matts Bikes',
                                      address: '123 High St',
                                      city: 'Denver',
                                      state: 'CO',
                                      zip: 80210,
                                      enabled: true)
     @mike = @bike_shop.users.create!(name: "Mike",
                                      address: "124 Vine St",
                                      city: "Denver",
                                      state: "CO",
                                      zip: "80206",
                                      email: "mike@gmail.com",
                                      password: "mike",
                                      role: 2)

      @discount1 = @bike_shop.discounts.create!(title: "Bulk Discount",
                                                percent_off: 5,
                                                information: "Thanks for buying in bulk",
                                                lowest_amount: 5,
                                                highest_amount: 9)
      @discount2 = @bike_shop.discounts.create!(title: "huge Discount",
                                                percent_off: 20,
                                                information: "Thanks for buying in bulk",
                                                lowest_amount: 10,
                                                highest_amount: 19)
      @discount3 = @bike_shop.discounts.create!(title: "Giant Discount",
                                                percent_off: 25,
                                                information: "Thanks for buying in bulk",
                                                lowest_amount: 20,
                                                highest_amount: 29)
      visit "/login"
      fill_in :email, with: @mike.email
      fill_in :password, with: @mike.password
      click_button "Log In"
      click_link "Merchant Dashboard"
    end
    it "I see a link that takes me to my shops discount index" do
      expect(current_path).to eq("/merchant")
      click_link 'Store Discount Index'
      expect(current_path).to eq("/merchant/discounts")
      expect(page).to have_content(@discount1.title)
      expect(page).to have_content(@discount1.discount_range)
      expect(page).to have_content(@discount1.percent_off)

      expect(page).to have_content(@discount2.title)
      expect(page).to have_content(@discount2.discount_range)
      expect(page).to have_content(@discount2.percent_off)

      expect(page).to have_content(@discount3.title)
      expect(page).to have_content(@discount3.discount_range)
      expect(page).to have_content(@discount3.percent_off)

    end
  end
end
