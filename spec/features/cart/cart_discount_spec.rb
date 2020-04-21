require 'rails_helper'

RSpec.describe "As a User" do
  before(:each) do
    user = create(:regular_user)
    merchant = create(:merchant)
    @item = create(:item, merchant: merchant, price: 10, inventory: 10)
    @discount = merchant.discounts.create(percent_off: 10, minimum_quantity: 5)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit "/items/#{@item.id}"
    click_button "Add to Cart"
    visit "/cart"
  end

  it "I receive a bulk discount when I add the minimum quantity of an item" do
    expect(page).to have_content("Subtotal: $10.00")
    4.times do
      click_button "More of This!"
    end
    expect(page).to have_content("Bulk Discount: -$5.00")
    expect(page).to have_content("Subtotal: $45.0")
    expect(page).to have_content("Total: $45.0")
  end
end