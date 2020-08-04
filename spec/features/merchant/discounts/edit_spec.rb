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

    expect(current_path).to eq("/merchant/discounts/#{discount_2.id}/edit")
    expect(page).to have_content("Edit Discount: #{discount_2.id}")
    expect(find_field('Percent').value).to eq(discount_2.percent.to_s)
    expect(find_field('quantity required').value).to eq(discount_2.quantity_required.to_s)

    fill_in "Percent", with: 20
    fill_in "quantity required", with: 10

    click_button "Submit"

    expect(current_path).to eq("/merchant/discounts")

    expect(page).to have_content("Discount #{discount_2.id} has been successfully updated.")
    within "#discount-row-#{discount_2.id}" do
      expect(page).to have_content("#{discount_2.id} 20% 10")
    end
  end

  it "doesn't allow a duplicated discount" do
    merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
    m_user = merchant_1.users.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: 1)
    discount_1 = merchant_1.discounts.create!(percent: 5, quantity_required: 10)
    discount_2 = merchant_1.discounts.create!(percent: 10, quantity_required: 15)

    visit "/login"
    fill_in :email, with: m_user.email
    fill_in :password, with: m_user.password
    click_button "Log In"

    visit "/merchant/discounts"

    within "#discount-row-#{discount_2.id}" do
      click_link "Edit"
    end

    fill_in "Percent", with: 5
    fill_in "quantity required", with: 10

    click_button "Submit"

    expect(page).to have_content("This discount already exists for your shop, please try again.")

    expect(current_path).to eq("/merchant/discounts/#{discount_2.id}/edit")
  end
end
