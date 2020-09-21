require "rails_helper"

RSpec.describe "Destroy a Discount as a Merchant Employee" do

  before :each do
    @dunder_mifflin = Merchant.create!(name: 'Dunder Mifflin Paper Company, Inc.', address: '1725 Slough Avenue', city: 'Scranton', state: 'PA', zip: 18505)
    @dwight = @dunder_mifflin.users.create!(name: "Dwight Kurt Schrute III", address: "123 Beet Farm", city: "Scranton", state: "PA", zip: 18510, email: "d-money@email.com", password: "angela", role: 1)
    @discount1 = @dunder_mifflin.discounts.create!(name: "50% off 10 or more items!", item_amount: 10, discount_percentage: 50)
    @discount2 = @dunder_mifflin.discounts.create!(name: "20% off 2 or more items!", item_amount: 2, discount_percentage: 20)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@dwight)
  end

  it "displays a link where I can destroy an existing discount" do
    visit "/merchant/discounts"

    within "#discount-#{@discount1.id}" do
      expect(page).to have_link("Delete")
      click_on "Delete"
    end

    expect(current_path).to eq("/merchant/discounts")
    expect(page).to have_content("Discount was successfully deleted!")
    # expect(page).to_not have_content(@discount1.name)
    # expect(page).to_not have_content(@discount1.item_amount)
    # expect(page).to_not have_content(@discount1.discount_percentage)
  end

end
