require 'rails_helper'

RSpec.describe "As a Merchant Employee" do
  before(:each) do
    merchant = create(:merchant)
    m_user = create(:merchant_employee, merchant: merchant)
    @discount = merchant.discounts.create(percent_off: 5, minimum_quantity: 5)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(m_user)
    visit edit_merchant_discount_path(@discount)
  end

  it "I can edit one of my discounts" do
    expect(page).to have_field(:percent_off, with: @discount.percent_off)
    expect(page).to have_field(:minimum_quantity, with: @discount.minimum_quantity)

    percent_off = 10
    minimum_quantity = 10

    fill_in :percent_off, with: percent_off
    fill_in :minimum_quantity, with: minimum_quantity
    click_button "Update Discount"

    expect(current_path).to eq(merchant_discount_path(@discount))
    expect(page).to have_content("Percent Off: #{percent_off}%")
    expect(page).to have_content("Minimum Quantity: #{minimum_quantity}")
  end

  it "I cannot update a discount with missing required fields" do
    percent_off = 10
    minimum_quantity = nil

    fill_in :percent_off, with: percent_off
    fill_in :minimum_quantity, with: minimum_quantity
    click_button "Update"

    expect(current_path).to eq(merchant_discount_path(@discount))
    expect(page).to have_content("Minimum quantity can't be blank")
    expect(page).to have_field(:percent_off, with: percent_off)

    percent_off = nil
    minimum_quantity = 10

    fill_in :percent_off, with: percent_off
    fill_in :minimum_quantity, with: minimum_quantity
    click_button "Update"

    expect(current_path).to eq(merchant_discount_path(@discount))
    expect(page).to have_content("Percent off can't be blank")
    expect(page).to have_field(:minimum_quantity, with: minimum_quantity)
  end

  it "I cannot update a discount with non-digit fields" do
    percent_off = 10
    minimum_quantity = "ten"

    fill_in :percent_off, with: percent_off
    fill_in :minimum_quantity, with: minimum_quantity
    click_button "Update"

    expect(current_path).to eq(merchant_discount_path(@discount))
    expect(page).to have_content("Minimum quantity is not a number")
    expect(page).to have_field(:percent_off, with: percent_off)

    percent_off = "ten"
    minimum_quantity = 10

    fill_in :percent_off, with: percent_off
    fill_in :minimum_quantity, with: minimum_quantity
    click_button "Update"

    expect(current_path).to eq(merchant_discount_path(@discount))
    expect(page).to have_content("Percent off is not a number")
    expect(page).to have_field(:minimum_quantity, with: minimum_quantity)
  end

end