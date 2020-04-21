require "rails_helper"

RSpec.describe "Bulk discount index page" do
  describe "As a Merchant user" do
    before :each do
      @merchant_1 = Merchant.create!(
        name: 'Megans Marmalades',
        address: '123 Main St',
        city: 'Denver',
        state: 'CO',
        zip: 80218)
      @merchant_2 = Merchant.create!(
        name: 'Brians Bagels',
        address: '125 Main St',
        city: 'Denver',
        state: 'CO',
        zip: 80218)
      @merchant_user = @merchant_1.users.create(
        name: 'Megan',
        address: '123 Main St',
        city: 'Denver',
        state: 'CO',
        zip: 80218,
        email: 'megan@example.com',
        password: 'securepassword')
      @ogre = @merchant_1.items.create!(
        name: 'Ogre',
        description: "I'm an Ogre!",
        price: 20.25,
        image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw',
        active: true,
        inventory: 5 )
      @giant = @merchant_1.items.create!(
        name: 'Giant',
        description: "I'm a Giant!",
        price: 50,
        image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw',
        active: true,
        inventory: 3 )
      @hippo = @merchant_2.items.create!(name: 'Hippo',
        description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw',
        active: true,
        inventory: 1 )

      @order_1 = @merchant_user.orders.create!(status: "pending")
      @order_2 = @merchant_user.orders.create!(status: "pending")
      @order_3 = @merchant_user.orders.create!(status: "pending")

      @order_item_1 = @order_1.order_items.create!(
        item: @hippo,
        price: @hippo.price,
        quantity: 2,
        fulfilled: false)
      @order_item_2 = @order_2.order_items.create!(
        item: @hippo,
        price: @hippo.price,
        quantity: 2,
        fulfilled: true)
      @order_item_3 = @order_2.order_items.create!(
        item: @ogre,
        price: @ogre.price,
        quantity: 2,
        fulfilled: false)
      @order_item_4 = @order_3.order_items.create!(
        item: @giant,
        price: @giant.price,
        quantity: 2,
        fulfilled: false)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
    end

    context "when I visit my discount show page" do
      before :each do
        @discount1 = @merchant_1.discounts.create!(name: "Family size discount", threshold: 10, percent: 0.1)
        @discount2 = @merchant_1.discounts.create!(name: "Shipping supply discount", threshold: 500, percent: 0.2)
      end

      it "I see all of that discount's info" do
        visit "/merchant/discounts/#{@discount1.id}"

        expect(page).to have_content(@discount1.name)
        expect(page).to have_content("Discount Threshold: #{@discount1.threshold}")
        expect(page).to have_content("Discount Percentage: #{(@discount1.percent * 100).round(2)}%")
      end
    end
  end
end

# **User Story 2: Bulk Discount Show Page**
# - As a Merchant user
# - When I visit my Bulk Discount index page
# - And I click on the name of a bulk discount
# - I am directed to a Bulk Discount show page
# - Where I see the discount's name, percentage, and threshold
