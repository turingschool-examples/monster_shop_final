require 'rails_helper'

RSpec.describe 'Updating a merchant discount' do
  describe 'As an employee of a merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @discount_1 = @merchant_1.discounts.create(percent: 5, quantity: 10)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it "I can update a merchant discount" do
      percent = 10
      quantity = 20
      visit '/merchant/discounts'

      within ".discount-#{@discount_1.id}" do
        click_on 'Edit Discount'
      end

      expect(current_path).to eq("/merchant/discounts/#{@discount_1.id}/edit")

      fill_in "Percent Off", with: percent
      fill_in "Item Quantity", with: quantity
      click_on 'Update Discount'

      expect(current_path).to eq("/merchant/discounts")
      expect(page).to have_content("Discount #{@discount_1.id} successfully updated")

      within ".discount-#{@discount_1.id}" do
        expect(page).to have_content("Discount ID: #{@discount_1.id}")
        expect(page).to have_content("Percent Off: 10%")
        expect(page).to have_content("Required Item Quantity: 20 units")
      end
    end

    it "I cannot update a discount with incomplete information" do
      visit '/merchant/discounts'

      within ".discount-#{@discount_1.id}" do
        click_on 'Edit Discount'
      end

      fill_in "Percent Off", with: ""
      fill_in "Item Quantity", with: ""

      click_on 'Update Discount'

      expect(current_path).to eq("/merchant/discounts/#{@discount_1.id}/edit")
      expect(page).to have_content("Percent can't be blank")
      expect(page).to have_content("Quantity can't be blank")
    end

    it "I cannot update a discount with information that's the wrong data type" do
      percent = "five"
      quantity = "ten"

      visit '/merchant/discounts'

      within ".discount-#{@discount_1.id}" do
        click_on 'Edit Discount'
      end

      fill_in "Percent Off", with: percent
      fill_in "Item Quantity", with: quantity

      click_on 'Update Discount'

      expect(current_path).to eq("/merchant/discounts/#{@discount_1.id}/edit")
      expect(page).to have_content("Percent is not a number")
      expect(page).to have_content("Quantity is not a number")
    end

    it "I cannot update a discount if a duplicate discount exists" do
      @merchant_1.discounts.create(percent: 10, quantity: 20)
      percent = 10
      quantity = 20

      visit '/merchant/discounts'

      within ".discount-#{@discount_1.id}" do
        click_on 'Edit Discount'
      end

      fill_in "Percent Off", with: percent
      fill_in "Item Quantity", with: quantity
      click_on 'Update Discount'

      expect(current_path).to eq("/merchant/discounts/#{@discount_1.id}/edit")
      expect(page).to have_content("This discount already exists")
    end

    it "A different merchant can update their discount with the same info as another merchants discount" do
      @merchant_2.discounts.create(percent: 10, quantity: 20)
      percent = 10
      quantity = 20

      visit '/merchant/discounts'

      within ".discount-#{@discount_1.id}" do
        click_on 'Edit Discount'
      end

      fill_in "Percent Off", with: percent
      fill_in "Item Quantity", with: quantity
      click_on "Update Discount"

      expect(current_path).to eq('/merchant/discounts')
      expect(page).to have_content("Discount #{@discount_1.id} successfully updated")
    end
  end
end
