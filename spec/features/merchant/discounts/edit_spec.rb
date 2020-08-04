require "rails_helper"

RSpec.describe "as a merchant user" do
  it "I can edit my existing discounts" do
    merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
    m_user = merchant_1.users.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: 1)
    discount_1 = merchant_1.discounts.create!(percent: 5, quantity_required: 10)
    discount_2 = merchant_1.discounts.create!(percent: 10, quantity_required: 15)

    visit "/login"
    fill_in :email, with: m_user.email
    fill_in :password, with: m_user.password
    click_button "Log In"

    visit "/merchant/discounts"
    
    within "#discount-row-#{discount_1.id}" do
      expect(page).to have_link("Edit")
    end

    within "#discount-row-#{discount_2.id}" do
      expect(page).to have_link("Edit")
      click_link "Edit"
    end

    expect(current_path).to eq("/merchant/discount/#{discount_1.id}/edit")
  end
end
