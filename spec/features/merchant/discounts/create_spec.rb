require 'rails_helper'

RSpec.describe 'Merchant Discount Index Page' do
  describe 'As an employee of a merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it "I can create a new discount" do
      percent = 15
      quantity = 30

      visit '/merchant/discounts'

      click_on "Create A Discount"

      expect(current_path).to eq('/merchant/discounts/new')

      fill_in "Percent Off", with: percent
      fill_in "Item Quantity", with: quantity
      click_on "Create Discount"

      new_discount = Discount.last

      expect(current_path).to eq('/merchant/discounts')

      expect(page).to have_content('Discount successfully created')

      within ".discount-#{new_discount.id}" do
        expect(page).to have_content("Discount ID: #{new_discount.id}")
        expect(page).to have_content("Percent Off: #{new_discount.percent}")
        expect(page).to have_content("Required Item Quantity: #{new_discount.quantity} units")
      end
    end

    it "I cannot create a discount with incomplete information" do
      visit '/merchant/discounts'

      click_on "Create A Discount"

      click_on "Create Discount"

      expect(current_path).to eq('/merchant/discounts/new')
      expect(page).to have_content("Percent can't be blank")
      expect(page).to have_content("Quantity can't be blank")
    end

    it "I cannot create a discount with information that's the wrong data type" do
      percent = "five"
      quantity = "ten"

      visit '/merchant/discounts'

      click_on "Create A Discount"

      fill_in "Percent Off", with: percent
      fill_in "Item Quantity", with: quantity

      click_on "Create Discount"

      expect(current_path).to eq('/merchant/discounts/new')
      expect(page).to have_content("Percent is not a number")
      expect(page).to have_content("Quantity is not a number")
    end

    it "I cannot create a duplicate discount" do
      @merchant_1.discounts.create(percent: 10, quantity: 20)
      percent = 10
      quantity = 20

      visit '/merchant/discounts'

      click_on "Create A Discount"

      fill_in "Percent Off", with: percent
      fill_in "Item Quantity", with: quantity
      click_on "Create Discount"

      expect(current_path).to eq('/merchant/discounts/new')
      expect(page).to have_content("This discount already exists")
    end

    it "A different merchant can create a duplicate discount" do
      @merchant_2.discounts.create(percent: 10, quantity: 20)
      percent = 10
      quantity = 20

      visit '/merchant/discounts'

      click_on "Create A Discount"

      fill_in "Percent Off", with: percent
      fill_in "Item Quantity", with: quantity
      click_on "Create Discount"

      expect(current_path).to eq('/merchant/discounts')
      expect(page).to have_content("Discount successfully created")
    end
  end
end
