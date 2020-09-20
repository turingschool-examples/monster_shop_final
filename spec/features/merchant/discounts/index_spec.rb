require "rails_helper"

RSpec.describe "Discount Index Page as a Merchant Employee" do

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

  it "displays a link to view all discounts available for that merchant" do

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
  end

end
