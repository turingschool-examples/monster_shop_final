require 'rails_helper'

RSpec.describe "As a Merchant Employee" do
  before(:each) do
    @merchant = create(:merchant)
    @m_user = create(:merchant_employee, merchant: @merchant)
    @discount1 = Discount.create!(discount: 5, min_quantity: 20, merchant: @merchant)
    @discount2 = Discount.create!(discount: 10, min_quantity: 25, merchant: @merchant)
    @item1 = create(:item)
    @item2 = create(:item)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
  end

  it "I can view my all of my discounts" do
    visit "/merchant/discounts"

    within("#discount-#{@discount1.id}") do
      expect(page).to have_content("Discount ##{@discount1.id}")
      expect(page).to have_content("Discount: #{@discount1.pct_off}%")
      expect(page).to have_content("Minimum Quantity: #{@discount1.min_quantity}")
    end

    within("#discount-#{@discount2.id}") do
      expect(page).to have_content("Discount ##{@discount2.id}")
      expect(page).to have_content("Discount: #{@discount2.pct_off}%")
      expect(page).to have_content("Minimum Quantity: #{@discount2.min_quantity}")
    end
  end
end