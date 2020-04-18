require 'rails_helper'

RSpec.describe "As a Merchant Employee" do
  before(:each) do
    merchant = create(:merchant)
    m_user = create(:merchant_employee, merchant: merchant)
    @discount = merchant.discounts.create(percent_off: 5, minimum_quantity: 20)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(m_user)
    visit "/merchant/discounts/#{@discount.id}"
  end

  it "I can delete one of my discounts" do
    click_link "Delete Discount"

    expect(current_path).to eq("/merchant/discounts")
    expect(page).to have_no_content("Discount ##{@discount.id}")
    expect(page).to have_no_content("Percent Off: #{@discount.percent_off}%")
    expect(page).to have_no_content("Minimum Quantity: #{@discount.minimum_quantity}")
  end
end
