require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Cart Show Page' do
  describe 'As a regular user' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 50 )
      @reg_user = User.create(name: "Regular User", address:"321 Fake St.", city: "Arvada", state: "CO", zip: "80301", email: "user@example.com", password: "password_regular")
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@reg_user)
    end

    describe 'I can have discounts applied' do
      it 'automaticaly if the quantity is reached' do
        discount_1 = Discount.create!(quantity: 5, percentage: 10, merchant_id: @brian.id)

        visit item_path(@ogre)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'

        visit '/cart'

        within "#item-#{@hippo.id}" do
          click_button('More of This!')
          click_button('More of This!')
          click_button('More of This!')
          click_button('More of This!')
        end
        
        within "#item-#{@hippo.id}" do
          expect(page).to have_content('Subtotal: $225.00')
        end
      end
      
      it 'and it defaults to the largest applicable discount' do
        discount_2 = Discount.create!(quantity: 10, percentage: 20, merchant_id: @brian.id)
        discount_1 = Discount.create!(quantity: 5, percentage: 10, merchant_id: @brian.id)

        visit item_path(@ogre)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'

        visit '/cart'

        within "#item-#{@hippo.id}" do
          click_button('More of This!')
          click_button('More of This!')
          click_button('More of This!')
          click_button('More of This!')
        end
        
        within "#item-#{@hippo.id}" do
          expect(page).to have_content('Subtotal: $225.00')
        end
        
        within "#item-#{@hippo.id}" do
          click_button('More of This!')
          click_button('More of This!')
          click_button('More of This!')
          click_button('More of This!')
          click_button('More of This!')
        end
        within "#item-#{@hippo.id}" do
          expect(page).to have_content('Subtotal: $400.00')
        end
      end
    end
  end
end
