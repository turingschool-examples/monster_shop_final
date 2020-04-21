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

    context "when I visit my discount index page" do
      it "I see all my merchant's discounts and their information" do
        discount1 = @merchant_1.discounts.create!(name: "Family size discount", threshold: 10, percent: 0.1)
        discount2 = @merchant_1.discounts.create!(name: "Shipping supply discount", threshold: 500, percent: 0.2)

        visit "/merchant/discounts"

        within "#discount-#{discount1.id}" do
          expect(page).to have_content(discount1.name)
          expect(page).to have_content("Discount Threshold: #{discount1.threshold}")
          expect(page).to have_content("Discount Percentage: #{(discount1.percent * 100).round(2)}%")
        end

        within "#discount-#{discount2.id}" do
          expect(page).to have_content(discount2.name)
          expect(page).to have_content("Discount Threshold: #{discount2.threshold}")
          expect(page).to have_content("Discount Percentage: #{(discount2.percent * 100).round(2)}%")
        end
      end

      it "if there are no discounts in the system, I see a message saying there are no discounts" do
        visit "/merchant/discounts"

        expect(page).to have_content("No current bulk discounts")
      end

      it "the names of each of the discounts are links to their respective discount show page" do
        discount1 = @merchant_1.discounts.create!(name: "Family size discount", threshold: 10, percent: 0.1)
        visit "/merchant/discounts"

        within "#discount-#{discount1.id}" do
          click_link discount1.name
        end

        expect(current_path).to eq("/merchant/discounts/#{discount1.id}")
      end

      it 'I can link to create a new discount from the discount index' do
        visit '/merchant/discounts'

        click_link 'New Bulk Discount'

        expect(current_path).to eq('/merchant/discounts/new')
      end
    end
  end
end
