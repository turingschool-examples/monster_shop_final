require 'rails_helper'

RSpec.describe 'Merchant Discount Edit Page' do
  describe 'As a Merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @ogre = @merchant_1.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @merchant_1.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @merchant_2.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 1 )
      @order_1 = @m_user.orders.create!(status: "pending")
      @order_2 = @m_user.orders.create!(status: "pending")
      @order_item_1 = @order_1.order_items.create!(item: @hippo, price: @hippo.price, quantity: 2, fulfilled: false)
      @order_item_2 = @order_2.order_items.create!(item: @hippo, price: @hippo.price, quantity: 2, fulfilled: true)
      @order_item_3 = @order_2.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: false)
      @order_item_4 = @order_2.order_items.create!(item: @giant, price: @giant.price, quantity: 2, fulfilled: false)
      @discount_1 = @merchant_1.discounts.create(percentage: 5, required_amount: 10)
    end

    it 'I can access a bulk discount edit page via the bulk discounts index page' do
      visit '/login'

      fill_in 'Email', with: 'megan@example.com'
      fill_in 'Password', with: 'securepassword'
      click_button 'Log In'

      visit '/merchant/discounts'

      within "#discount-#{@discount_1.id}" do
        expect(page).to have_content('Discount Percentage: 5%')
        expect(page).to have_content('Required Item Quantity: 10')
        expect(page).to have_link("Edit Discount")
        click_link 'Edit Discount'
      end

      expect(current_path).to eq("/merchant/discounts/edit/#{@discount_1.id}")
    end

    it 'I can edit an existing bulk discount' do
      visit '/login'
      fill_in 'Email', with: @m_user.email
      fill_in 'Password', with: @m_user.password
      click_button 'Log In'

      visit '/merchant/discounts'

      within "#discount-#{@discount_1.id}" do
        expect(page).to have_content('Discount Percentage: 5%')
        expect(page).to have_content('Required Item Quantity: 10')
        click_link 'Edit Discount'
      end

      expect(current_path).to eq("/merchant/discounts/edit/#{@discount_1.id}")

      percentage = 5
      required_amount = 20

      fill_in 'Percentage', with: percentage
      fill_in 'Required amount', with: required_amount

      click_button 'Update Bulk Discount'

      expect(current_path).to eq('/merchant/discounts')

      within "#discount-#{@discount_1.id}" do
        expect(page).to have_content('Discount Percentage: 5%')
        expect(page).to have_content('Required Item Quantity: 20')
      end
    end
  end
end
