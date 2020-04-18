require 'rails_helper'

RSpec.describe "As a Merchant Employee" do
  before(:each) do
    merchant = create(:merchant)
    m_user = create(:merchant_employee, merchant: merchant)
    @discount = merchant.discounts.create(percent_off: 5, minimum_quantity: 20)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(m_user)
    visit "/merchant/discounts/#{@discount.id}/edit"
  end

  it "I can edit one of my discounts" do
    percent_off = 25
    minimum_quantity = 5

    fill_in :percent_off, with: percent_off
    fill_in :minimum_quantity, with: minimum_quantity
    click_button "Update Discount"

    expect(current_path).to eq("/merchant/discounts/#{@discount.id}")
    expect(page).to have_content("Percent Off: #{percent_off}%")
    expect(page).to have_content("Minimum Quantity: #{minimum_quantity}")
  end
end