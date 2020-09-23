require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Order Show Page' do
    it 'I shows discounts applied in the order show page.' do
        megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
        ogre = megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 50 )
        giant = megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 30 )
        discount_1 = megan.discounts.create!(threshold_quantity: 5, discount_percentage: 10)
        user = User.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan_1@example.com', password: 'securepassword')
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

        visit item_path(ogre)
        click_button 'Add to Cart'
        visit item_path(giant)
        click_button 'Add to Cart'

        visit '/cart'
        
        within "#item-#{ogre.id}" do
            4.times do
                click_button "More of This!"
            end
        end
        click_button "Check Out"
        
        orders = Order.all

        click_link "#{orders.first.id}"

        expect(page).to have_content("Total: $140.00")
        expect(page).to have_content("Subtotal: $90.00")
        expect(page).to have_content("Subtotal: $50.00")
    end
end