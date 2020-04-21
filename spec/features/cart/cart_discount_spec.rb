require 'rails_helper'

RSpec.describe "As a User" do
  before(:each) do
    user = create(:regular_user)
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)
    @item1 = create(:item, merchant: merchant1, price: 10, inventory: 10)
    @item2 = create(:item, merchant: merchant2, price: 10, inventory: 10)
    merchant1.discounts.create(percent_off: 5, minimum_quantity: 5)
    merchant1.discounts.create(percent_off: 10, minimum_quantity: 5)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit "/items/#{@item1.id}"
    click_button "Add to Cart"
  end

  it "I receive the best applicable bulk discount when I add the minimum quantity of an item" do
    visit "/cart"
    within("#item-#{@item1.id}") do
      4.times do
        click_button "More of This!"
      end
      expect(page).to have_content("Bulk Discount: -$5.00")
      expect(page).to have_content("Subtotal: $45.00")
    end
    expect(page).to have_content("Total: $45.00")
  end

  it "A merchant's discount applies only to their items" do
    visit "/items/#{@item2.id}"
    click_button "Add to Cart"
    visit "/cart"

    within("#item-#{@item1.id}") do
      4.times do
        click_button "More of This!"
      end
      expect(page).to have_content("Bulk Discount: -$5.00")
      expect(page).to have_content("Subtotal: $45.00")
    end

    within("#item-#{@item2.id}") do
      4.times do
        click_button "More of This!"
      end
      expect(page).to have_no_content("Bulk Discount")
      expect(page).to have_content("Subtotal: $50.0")
    end
    expect(page).to have_content("Total: $95.00")
  end
end