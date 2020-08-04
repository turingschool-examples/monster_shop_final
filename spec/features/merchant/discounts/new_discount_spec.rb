require "rails_helper"

RSpec.describe "as a merchant user" do
  it "can create a new discount" do
    merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
    m_user = merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: 1)

    visit "/login"
    fill_in :email, with: m_user.email
    fill_in :password, with: m_user.password
    click_button "Log In"

    visit "/merchant/discounts"

    expect(page).to have_link("Create New Discount")

    click_link "Create New Discount"

    expect(current_path).to eq("/merchant/discounts/new")
save_and_open_page
    expect(page).to have_content("Percent discount:")
    expect(page).to have_content("Minimum item quantity required for discount:")
    # how to have input field display something different than what gets passed in params?
    fill_in "Percent", with: 5
    fill_in "quantity required", with: 10

    click_button "Submit"

    expect(current_path).to eq("/merchant/discounts")

    # make a table in erb?
    expect(page).to have_content("New discount created.")
    # expect(page).to have_content("ID: ")
    expect(page).to have_content("Percent: #{percent}%")
    expect(page).to have_content("Minimum item quantity: #{quantity}")
  end
end
