require 'rails_helper'

RSpec.describe 'Merchant Discounts Index Page' do
  describe 'As an employee of a merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @ogre = @merchant_1.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @merchant_1.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @merchant_2.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 1 )
      @order_1 = @m_user.orders.create!(status: "pending")
      @order_2 = @m_user.orders.create!(status: "pending")
      @order_3 = @m_user.orders.create!(status: "pending")
      @order_item_1 = @order_1.order_items.create!(item: @hippo, price: @hippo.price, quantity: 2, fulfilled: false)
      @order_item_2 = @order_2.order_items.create!(item: @hippo, price: @hippo.price, quantity: 2, fulfilled: true)
      @order_item_3 = @order_2.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: false)
      @order_item_4 = @order_3.order_items.create!(item: @giant, price: @giant.price, quantity: 2, fulfilled: false)
      @discount_1 = @merchant_1.discounts.create!(quantity: 2, amount: 5)
      @discount_2 = @merchant_1.discounts.create!(quantity: 5, amount: 10)
      @discount_2 = @merchant_1.discounts.create!(quantity: 5, amount: 10)
      
      visit '/login'
      fill_in 'Email', with: @m_user.email  
      fill_in 'Password', with: @m_user.password
      click_button 'Log In'
    end

    it 'I can visit the discounts page' do
      visit '/merchant'

      click_link 'Bulk Discounts'
      expect(current_path).to eq('/merchant/discounts')
    end

    it 'I can see all of the the discounts I offer' do
      visit '/merchant/discounts'

      within "#discount-#{@discount_1.id}" do
        expect(page).to have_content("Discount #{@discount_1.id}")
        expect(page).to have_content("Discount: #{@discount_1.amount}%")
        expect(page).to have_content("Quantity at which Discount is Applied: #{@discount_1.quantity}")
      end

      within "#discount-#{@discount_2.id}" do
        expect(page).to have_content("Discount #{@discount_2.id}")
        expect(page).to have_content("Discount: #{@discount_2.amount}%")
        expect(page).to have_content("Quantity at which Discount is Applied: #{@discount_2.quantity}")
      end
    end
          
    it 'I see a link to create a new discount' do
      visit '/merchant/discounts'

      click_link 'New Bulk Discount'
      expect(current_path).to eq('/merchant/discounts/new')
    end

    it 'I see a link to edit a discount' do
      visit '/merchant/discounts'

      within "#discount-#{@discount_1.id}" do
        click_link 'Edit Discount'
      end
      expect(current_path).to eq("/merchant/discounts/#{@discount_1.id}/edit")
    end

    it 'I see a link to delete a discount' do
      visit '/merchant/discounts'

      within "#discount-#{@discount_1.id}" do
        click_link 'Delete Discount'
      end
      expect(current_path).to eq("/merchant/discounts")
    end
  end
end