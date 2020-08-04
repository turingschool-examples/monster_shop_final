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
    expect(page).to have_content("Percent discount:")
    expect(page).to have_content("Minimum item quantity required for discount:")

    fill_in "Percent", with: 5
    fill_in "quantity required", with: 10

    click_button "Submit"

    expect(current_path).to eq("/merchant/discounts")

    save_and_open_page
    expect(page).to have_content("New discount created.")
    expect(page).to have_content("5%")
    expect(page).to have_content("10")
  end

  it "does not allow a merchant user to create a discount that already exists" do
  end
end
