require 'rails_helper'

RSpec.describe 'User Order Show Page' do
  describe 'As a Registered User' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @sal = Merchant.create!(name: 'Sals Salamanders', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @user = User.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan_1@example.com', password: 'securepassword')
      @order_1 = @user.orders.create!
      @order_2 = @user.orders.create!
      @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2)
      @order_2.order_items.create!(item: @giant, price: @hippo.price, quantity: 2)
      @order_2.order_items.create!(item: @ogre, price: @hippo.price, quantity: 2)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it 'I can link to my orders from my profile' do
      visit profile_dashboard_path

      click_link 'My Orders'

      expect(current_path).to eq('/profile/orders')
    end

    it 'I see order information on the show page' do
      visit '/profile/orders'

      within "#order-#{@order_1.id}" do
        expect(page).to have_link("#{@order_1.id}")
        expect(page).to have_content("Created On: #{@order_1.created_at}")
        expect(page).to have_content("Updated On: #{@order_1.updated_at}")
        expect(page).to have_content("Status: #{@order_1.status}")
        expect(page).to have_content("#{@order_1.count_of_items} items")
        expect(page).to have_content("Total: #{number_to_currency(@order_1.grand_total)}")
      end

      within "#order-#{@order_2.id}" do
        expect(page).to have_link("#{@order_2.id}")
        expect(page).to have_content("Created On: #{@order_2.created_at}")
        expect(page).to have_content("Updated On: #{@order_2.updated_at}")
        expect(page).to have_content("Status: #{@order_2.status}")
        expect(page).to have_content("#{@order_2.count_of_items} items")
        expect(page).to have_content("Total: #{number_to_currency(@order_2.grand_total)}")
      end
    end
  end
end
