require 'rails_helper'

RSpec.describe "discounts index page" do
  it "can be gotten to from a link on the merchant dashboard" do
    merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
    m_user = merchant_1.users.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: 1)
    discount_1 = merchant_1.discounts.create!(percent: 5, quantity_required: 10)
    discount_2 = merchant_1.discounts.create!(percent: 10, quantity_required: 15)

    visit "/login"
    fill_in :email, with: m_user.email
    fill_in :password, with: m_user.password
    click_button "Log In"

    visit "/merchant"

    expect(page).to have_link("Current Discounts")

    click_link "Current Discounts"

    expect(current_path).to eq("/merchant/discounts")
    expect(page).to have_content(discount_1.id)
    expect(page).to have_content(discount_1.percent)
    expect(page).to have_content(discount_1.quantity_required)
    expect(page).to have_content(discount_2.id)
    expect(page).to have_content(discount_2.percent)
    expect(page).to have_content(discount_2.quantity_required)
  end
end
