require "rails_helper"

RSpec.describe "Discount Index Page as a Merchant Employee" do

  before :each do
    @dunder_mifflin = Merchant.create!(name: 'Dunder Mifflin Paper Company, Inc.', address: '1725 Slough Avenue', city: 'Scranton', state: 'PA', zip: 18505)
    @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
    @dwight = @dunder_mifflin.users.create!(name: "Dwight Kurt Schrute III", address: "123 Beet Farm", city: "Scranton", state: "PA", zip: 18510, email: "d-money@email.com", password: "angela", role: 1)
    @discount1 = @dunder_mifflin.discounts.create!(name: "50% off 10 or more items!", item_amount: 10, discount_percentage: 50)
    @discount2 = @dunder_mifflin.discounts.create!(name: "20% off 2 or more items!", item_amount: 2, discount_percentage: 20)
    @discount3 = @megan.discounts.create!(name: "30% off 5 or more items!", item_amount: 2, discount_percentage: 20)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@dwight)
  end

  it "displays a link to view all discounts available for that merchant and not any other merchants" do

    visit "/merchant"

    expect(page).to have_link("Discounts")
    click_on "Discounts"
    expect(current_path).to eq("/merchant/discounts")

    within "#discount-#{@discount1.id}" do
      expect(page).to have_content(@discount1.name)
      expect(page).to have_content(@discount1.item_amount)
      expect(page).to have_content(@discount1.discount_percentage)
    end

    within "#discount-#{@discount2.id}" do
      expect(page).to have_content(@discount2.name)
      expect(page).to have_content(@discount2.item_amount)
      expect(page).to have_content(@discount2.discount_percentage)
    end

    expect(page).to_not have_content(@discount3.name)
  end

end
