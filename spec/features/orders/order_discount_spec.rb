require 'rails_helper'

RSpec.describe "As a User" do
  it "My order page shows a discount has been applied" do
    user = create(:regular_user)
    merchant = create(:merchant)
    item = create(:item, merchant: merchant, price: 10, inventory: 10)
    merchant.discounts.create(percent_off: 10, minimum_quantity: 5)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit "/items/#{item.id}"
    click_button "Add to Cart"
    visit "/cart"
    4.times do
      click_button "More of This!"
    end
    click_button "Check Out"
    expect(page).to have_content("Total: $45.00")
  end
end