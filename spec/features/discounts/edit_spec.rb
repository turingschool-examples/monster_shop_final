require 'rails_helper'

RSpec.describe 'New discount form' do
    describe 'As an employee of a merchant' do
        before :each do
            @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
            @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
          
            allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
        end

        it 'complete an edit on a discount' do
            discount_1 = @merchant_1.discounts.create(threshold_quantity: 10, discount_percentage: 5)
            discount_2 = @merchant_1.discounts.create(threshold_quantity: 30, discount_percentage: 15)

            visit '/merchant/'

            within "#discount-#{discount_1.id}" do 
                click_button "Update Discount"
            end

            expect(current_path).to eq("/merchant/discounts/#{discount_1.id}/edit")

            expect(find_field('Threshold quantity').value).to eq "10"
            expect(find_field('Discount percentage').value).to eq '5.0'

            fill_in "Threshold quantity", with: 20
            fill_in "Discount percentage", with: 25
            click_button "Update Discount"
            expect(current_path).to eq("/merchant")
            expect(page).to have_content("Discount Updated!")

            within "#discount-#{discount_1.id}" do 
                # expect(page).to have_content("20")
                # expect(page).to have_content("15")
                expect(page).to have_button("Delete Discount")
                expect(page).to have_button("Update Discount")
            end

            within "#discount-#{discount_2.id}" do 
                expect(page).to have_content("#{discount_2.discount_percentage}")
                expect(page).to have_content("#{discount_2.threshold_quantity}")
                expect(page).to have_button("Delete Discount")
                expect(page).to have_button("Update Discount")
            end
        end

        it 'Will not allow me to leave a field empty' do
            discount_1 = @merchant_1.discounts.create(threshold_quantity: 10, discount_percentage: 5)
            discount_2 = @merchant_1.discounts.create(threshold_quantity: 30, discount_percentage: 15)
            
            visit '/merchant'
    
            within "#discount-#{discount_1.id}" do 
                click_button "Update Discount"
            end

            fill_in "Threshold quantity", with: ""
            fill_in "Discount percentage", with: 10
    
            click_button "Update Discount"

            expect(page).to have_content("Threshold quantity can't be blank")
    
            fill_in "Threshold quantity", with: 5
            click_button "Update Discount"
            expect(current_path).to eq("/merchant")
    
        end
    end
end