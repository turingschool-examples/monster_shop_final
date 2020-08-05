require 'rails_helper'


RSpec.describe 'Item discounts' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @ogre = @merchant_1.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 25.00, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 15 )
      @giant = @merchant_1.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @discount1 = @merchant_1.discounts.create!(name: "Ogre Discount", percent_off: 10, min_quantity: 5)
      @discount2 = @merchant_1.discounts.create!(name: "Ogre Discount", percent_off: 20, min_quantity: 10)
      @user = User.create!(name: 'Ash', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'ash@example.com', password: 'securepassword')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it 'can place an order with the minimum quantity and discount is on orders show page' do
      visit visit "/items/#{@ogre.id}"

      click_button 'Add to Cart'

      visit '/cart'

      within "#item-#{@ogre.id}" do
        expect(page).to have_content("Subtotal: $25.00")

        click_button 'More of This!'
        click_button 'More of This!'
        click_button 'More of This!'
        click_button 'More of This!'

        expect(page).to have_content("Subtotal: $112.50")
      end
    end
end
