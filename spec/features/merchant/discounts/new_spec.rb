require "rails_helper"

RSpec.describe "Discount New Page as a Merchant Employee" do

  before :each do
    @dunder_mifflin = Merchant.create!(name: 'Dunder Mifflin Paper Company, Inc.', address: '1725 Slough Avenue', city: 'Scranton', state: 'PA', zip: 18505)
    @dwight = @dunder_mifflin.users.create!(name: "Dwight Kurt Schrute III", address: "123 Beet Farm", city: "Scranton", state: "PA", zip: 18510, email: "d-money@email.com", password: "angela", role: 1)
    @paper = @dunder_mifflin.items.create!(name: "Paper", description: "Premium copy papter", price: 20, image: 'https://dundermifflinpaper.com/wp-content/uploads/2013/06/20190824_185517.jpg', active: true, inventory: 50)
    @sweatshirt = @dunder_mifflin.items.create!(name: "Sweatshirt", description: "Soft and perfect for winter.", price: 20, image: 'https://teeshope.com/wp-content/uploads/2019/11/dunder-mifflin-inc-sweatshirt.jpg', active: true, inventory: 25)
    @pen = @dunder_mifflin.items.create!(name: "Pen", description: "Ball point black ink.", price: 3, image: 'https://dundermifflinpaper.com/wp-content/uploads/2019/09/IMG-0738.jpg', active: true, inventory: 50)
    @discount1 = @dunder_mifflin.discounts.create!(name: "50% off 10 or more items!", item_amount: 10, discount_percentage: 50)
    @discount2 = @dunder_mifflin.discounts.create!(name: "20% off 2 or more items!", item_amount: 2, discount_percentage: 20)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@dwight)
  end

  it "displays a link where I can create a new discount" do

    visit "/merchant/discounts"

    expect(page).to have_link("Create a New Discount")
    click_on "Create a New Discount"
    expect(current_path).to eq("/merchant/discounts/new")

    name = "60% off 15 or more items!"
    item_amount = 15
    discount_percentage = 60

    fill_in :name, with: name
    fill_in :item_amount, with: item_amount
    fill_in :discount_percentage, with: discount_percentage
    click_button "Create Discount"

    new_discount = Discount.last

    expect(current_path).to eq("/merchant/discounts")
    expect(page).to have_content("New discount created!")

    within "#discount-#{new_discount.id}" do
      expect(page).to have_content(new_discount.name)
      expect(page).to have_content(new_discount.item_amount)
      expect(page).to have_content(new_discount.discount_percentage)
    end
  end

  it "cannot make a new discount with negative numbers" do
    visit "/merchant/discounts"

    expect(page).to have_link("Create a New Discount")
    click_on "Create a New Discount"
    expect(current_path).to eq("/merchant/discounts/new")

    name = "60% off 15 or more items!"
    item_amount = -1
    discount_percentage = 20

    fill_in :name, with: name
    fill_in :item_amount, with: item_amount
    fill_in :discount_percentage, with: discount_percentage
    click_button "Create Discount"

    expect(current_path).to eq("/merchant/discounts/new")
    expect(page).to have_content("Item amount must be greater than 0")
  end

  it "cannot make a new discount with a percentage higher than 99" do
    visit "/merchant/discounts"

    expect(page).to have_link("Create a New Discount")
    click_on "Create a New Discount"
    expect(current_path).to eq("/merchant/discounts/new")

    name = "60% off 15 or more items!"
    item_amount = 12
    discount_percentage = 100

    fill_in :name, with: name
    fill_in :item_amount, with: item_amount
    fill_in :discount_percentage, with: discount_percentage
    click_button "Create Discount"

    expect(current_path).to eq("/merchant/discounts/new")
    expect(page).to have_content("Discount percentage must be 1 - 99")
  end

  it "cannot make a new discount with blank information" do
    visit "/merchant/discounts"

    expect(page).to have_link("Create a New Discount")
    click_on "Create a New Discount"
    expect(current_path).to eq("/merchant/discounts/new")

    fill_in :name, with: ""
    fill_in :item_amount, with: ""
    fill_in :discount_percentage, with: ""
    click_button "Create Discount"

    expect(current_path).to eq("/merchant/discounts/new")
    expect(page).to have_content("Name can't be blank, Item amount is not a number, and Discount percentage must be 1 - 99")
  end

end
