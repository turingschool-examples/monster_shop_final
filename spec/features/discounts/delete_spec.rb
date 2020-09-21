require 'rails_helper'

RSpec.describe 'New discount form' do
    describe 'As an employee of a merchant' do
        before :each do
            @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
            @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
            allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
        end

        it 'can delete a discount using the link' do
            discount_1 = @merchant_1.discounts.create(threshold_quantity: 10, discount_percentage: 5)
            discount_2 = @merchant_1.discounts.create(threshold_quantity: 30, discount_percentage: 15)

            visit '/merchant'
            within "#discount-#{discount_1.id}" do 
                expect(page).to have_button("Delete Discount")
            end
            
            within "#discount-#{discount_2.id}" do 
                expect(page).to have_button("Delete Discount")
            end
            
            within "#discount-#{discount_1.id}" do 
                click_button "Delete Discount"
            end
            
            expect(current_path).to eq('/merchant')

            expect(page).to have_content("Discount Removed")
            expect(page).to have_content("#{discount_2.threshold_quantity}")
            expect(page).to have_content("#{discount_2.discount_percentage}")
            
            # expect(page).to_not have_content("#{discount_1.threshold_quantity}")
            # expect(page).to_not have_content("#{discount_1.discount_percentage}")
            

            
        end
    end
end