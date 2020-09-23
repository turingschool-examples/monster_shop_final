require 'rails_helper'

RSpec.describe 'New discount form' do
  describe 'As an employee of a merchant' do
    before :each do
        @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
        @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
        
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'Will allow me to create a new discount' do
      visit '/merchant/discounts/new'

      fill_in "Threshold quantity", with: 10
      fill_in "Discount percentage", with: 5

      click_button "Submit New Discount"
      
      expect(current_path).to eq("/merchant")
      expect(page).to have_content("Discount Added")
      expect(page).to have_content("Discount Quantity")
      expect(page).to have_content("10")
      expect(page).to have_content("Discount Percentage")
      expect(page).to have_content("5")
      expect(page).to have_button("Delete Discount")
      expect(page).to have_button("Update Discount")

    end

    it 'Will not allow me to leave a field empty' do
      visit '/merchant/discounts/new'

      fill_in "Threshold quantity", with: 10
      fill_in "Discount percentage", with: ""

      click_button "Submit New Discount"
      expect(page).to have_content("Discount percentage can't be blank")

      fill_in "Discount percentage", with: 5.0
      click_button "Submit New Discount"
      expect(current_path).to eq("/merchant")

    end

    # it 'Will not allow me to fill in with a string' do
    #   visit '/merchant/discounts/new'

    #   fill_in "Threshold quantity", with: 10
    #   fill_in "Discount percentage", with: "seven"

    #   click_button "Submit New Discount"
    #   sleep 1
    #   expect(page).to have_content("Discount percentage can't be blank")
    # end

    it 'Will show multiple discounts' do
        discount_1 = @merchant_1.discounts.create(threshold_quantity: 10, discount_percentage: 5)
        discount_2 = @merchant_1.discounts.create(threshold_quantity: 30, discount_percentage: 15)
        discount_3 = @merchant_1.discounts.create(threshold_quantity: 50, discount_percentage: 25)

        visit '/merchant/'
    
        expect(page).to have_content("Discount Quantity")
        expect(page).to have_content("Discount Percentage")

        within "#discount-#{discount_1.id}" do 
            expect(page).to have_content("#{discount_1.discount_percentage}")
            expect(page).to have_content("#{discount_1.threshold_quantity}")
            expect(page).to have_button("Delete Discount")
            expect(page).to have_button("Update Discount")
        end
        within "#discount-#{discount_2.id}" do 
            expect(page).to have_content("#{discount_2.discount_percentage}")
            expect(page).to have_content("#{discount_2.threshold_quantity}")
            expect(page).to have_button("Delete Discount")
            expect(page).to have_button("Update Discount")
        end
        within "#discount-#{discount_3.id}" do 
            expect(page).to have_content("#{discount_3.discount_percentage}")
            expect(page).to have_content("#{discount_3.threshold_quantity}")
            expect(page).to have_button("Delete Discount")
            expect(page).to have_button("Update Discount")
        end
  
      end
  end
end