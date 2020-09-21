require "rails_helper"

RSpec.describe "Discount Edit Page as a Merchant Employee" do

  before :each do
    @dunder_mifflin = Merchant.create!(name: 'Dunder Mifflin Paper Company, Inc.', address: '1725 Slough Avenue', city: 'Scranton', state: 'PA', zip: 18505)
    @dwight = @dunder_mifflin.users.create!(name: "Dwight Kurt Schrute III", address: "123 Beet Farm", city: "Scranton", state: "PA", zip: 18510, email: "d-money@email.com", password: "angela", role: 1)
    @discount1 = @dunder_mifflin.discounts.create!(name: "50% off 10 or more items!", item_amount: 10, discount_percentage: 50)
    @discount2 = @dunder_mifflin.discounts.create!(name: "20% off 2 or more items!", item_amount: 2, discount_percentage: 20)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@dwight)
  end

  it "displays a link where I can edit an existing discount" do

    visit "/merchant/discounts"

    within "#discount-#{@discount1.id}" do
      expect(page).to have_content(@discount1.name)
      expect(page).to have_link("Edit")
      click_on "Edit"
    end

    expect(current_path).to eq("/merchant/discounts/#{@discount1.id}/edit")

    name = "Cool Stuff"
    item_amount = 15
    discount_percentage = 60

    fill_in :name, with: name
    fill_in :item_amount, with: item_amount
    fill_in :discount_percentage, with: discount_percentage
    click_button "Update Discount"

    expect(current_path).to eq("/merchant/discounts")
    expect(page).to have_content("#{@discount1.name} was successfully updated!")
    expect(page).to have_content("Cool Stuff")
  end

end
