require "rails_helper"

RSpec.describe "as a merchant user" do
  it "can create a new discount" do
    merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
    m_user = merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: 1)
    percent = "5"
    quantity = 10

    visit "/login"
    fill_in :email, with: m_user.email
    fill_in :password, with: m_user.password
    click_button "Log In"

    visit "/merchant/discounts"

    expect(page).to have_link("Create New Discount")

    click_link "Create New Discount"

    expect(current_path).to eq("/merchant/discounts/new")

    expect(page).to have_content("Percent discount:")
    expect(page).to have_content("Minimum item quantity required for discount:")
    # how to have input field display something different than what gets passed in params?
    fill_in :percent, with: "#{percent}"
    fill_in :quantity, with: quantity

    click_button "Submit"

    expect(current_path).to eq("/merchant/discounts")

    # make a table in erb?
    expect(page).to have_content("New discount created.")
    # expect(page).to have_content("ID: ")
    expect(page).to have_content("Percent: #{perent}%")
    expect(page).to have_content("Minimum item quantity: #{quantity}")
  end
end
