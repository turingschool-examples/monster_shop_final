require 'rails_helper'

RSpec.describe "As a Merchant Employee" do
  before(:each) do
    merchant = create(:merchant)
    m_user = create(:merchant_employee, merchant: merchant)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(m_user)
    visit new_merchant_discount_path
  end

  it "I can create a new discount" do
    percent_off = 5
    minimum_quantity = 5

    fill_in :percent_off, with: percent_off
    fill_in :minimum_quantity, with: minimum_quantity
    click_button "Create Discount"

    expect(current_path).to eq(merchant_discounts_path)
    expect(page).to have_content("Percent Off: #{percent_off}%")
    expect(page).to have_content("Minimum Quantity: #{minimum_quantity}")
  end

  it "I cannot create a new discount with missing required fields" do
    percent_off =  10
    minimum_quantity = nil

    fill_in :percent_off, with: percent_off
    fill_in :minimum_quantity, with: minimum_quantity
    click_button "Create Discount"

    expect(current_path).to eq(merchant_discounts_path)
    expect(page).to have_content("Minimum quantity can't be blank")
    expect(page).to have_field(:percent_off, with: percent_off)

    percent_off =  nil
    minimum_quantity = 10

    fill_in :percent_off, with: percent_off
    fill_in :minimum_quantity, with: minimum_quantity
    click_button "Create Discount"

    expect(current_path).to eq(merchant_discounts_path)
    expect(page).to have_content("Percent off can't be blank")
    expect(page).to have_field(:minimum_quantity, with: minimum_quantity)
  end

  it "I cannot create a discount with non-digit inputs" do
    percent_off = 10
    minimum_quantity = "ten"

    fill_in :percent_off, with: percent_off
    fill_in :minimum_quantity, with: minimum_quantity
    click_button "Create Discount"

    expect(current_path).to eq(merchant_discounts_path)
    expect(page).to have_content("Minimum quantity is not a number")
    expect(page).to have_field(:percent_off, with: percent_off)

    percent_off = "-"
    minimum_quantity = 10

    fill_in :percent_off, with: percent_off
    fill_in :minimum_quantity, with: minimum_quantity
    click_button "Create Discount"

    expect(current_path).to eq(merchant_discounts_path)
    expect(page).to have_content("Percent off is not a number")
    expect(page).to have_field(:minimum_quantity, with: minimum_quantity)
  end
end