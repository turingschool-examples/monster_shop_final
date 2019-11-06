# frozen_string_literal: true

require 'rails_helper'

describe 'As a User' do
  describe 'I have the ability to use a merchants coupons when I check out' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80_218)
      @ogre = @merchant_1.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5)
      @coupon_1 = @merchant_1.coupons.create!(name: 'Discount 1', discount: 10)

      @merchant_2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80_218)
      @hippo = @merchant_2.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 1)
      @coupon_2 = @merchant_2.coupons.create!(name: 'Discount 2', discount: 15)

      @merchant_3 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80_218)
      @giant = @merchant_3.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3)
      @coupon_3 = @merchant_3.coupons.create!(name: 'Discount 3', discount: 20)

      visit item_path(@ogre)
      click_button 'Add to Cart'
      visit item_path(@hippo)
      click_button 'Add to Cart'

      user = User.create!(name: 'Christopher', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80_218, email: 'ck@email.com', password: 'password')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit cart_path
    end

    it 'I see all available coupons from the merchants I am buying from. I do not see coupons from other merchants.' do
      within "#coupon-#{@coupon_1.id}" do
        expect(page).to have_content(@coupon_1.name)
        expect(page).to have_content(@coupon_1.discount)
      end

      within "#coupon-#{@coupon_2.id}" do
        expect(page).to have_content(@coupon_2.name)
        expect(page).to have_content(@coupon_2.discount)
      end

      expect(page).to_not have_content(@coupon_3.name)
    end

    it 'Users can only use one coupon per order' do
      within "#coupon-#{@coupon_1.id}" do
        click_button 'Select Coupon'
      end

      expect(current_path).to eq(cart_path)

      expect(page).to have_content("Currently Selected: #{@coupon_1.name}")

      within "#coupon-#{@coupon_2.id}" do
        click_button 'Select Coupon'
      end

      expect(page).to have_content("Currently Selected: #{@coupon_2.name}")
      expect(page).to_not have_content("Currently Selected: #{@coupon_1.name}")
    end

    it 'Coupons can only be used one time per user' do
      within "#coupon-#{@coupon_1.id}" do
        click_button 'Select Coupon'
      end

      click_button 'Check Out'

      visit item_path(@ogre)
      click_button 'Add to Cart'

      visit cart_path

      expect(page).to_not have_content(@coupon_1.name)
    end

    it 'Multiple users can use the same coupon' do
      within "#coupon-#{@coupon_1.id}" do
        click_button 'Select Coupon'
      end

      click_button 'Check Out'

      within 'nav' do
        click_link 'Log Out'
      end

      user_2 = User.create!(name: 'Christopher', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80_218, email: 'cj@email.com', password: 'password')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user_2)

      visit item_path(@ogre)
      click_button 'Add to Cart'

      visit cart_path

      within "#coupon-#{@coupon_1.id}" do
        click_button 'Select Coupon'
      end

      click_button 'Check Out'
    end

    it 'The user can select a coupon from the cart, then continue shopping. When they return to the cart their selection should be remembered.' do
      within "#coupon-#{@coupon_1.id}" do
        click_button 'Select Coupon'
      end

      expect(page).to have_content("Currently Selected: #{@coupon_1.name}")

      visit item_path(@giant)
      click_button 'Add to Cart'

      visit cart_path

      expect(page).to have_content("Currently Selected: #{@coupon_1.name}")
    end

    it 'The order index and show pages show the coupon that was used on that order' do
      within "#coupon-#{@coupon_1.id}" do
        click_button 'Select Coupon'
      end

      click_button 'Check Out'

      expect(page).to have_content("The #{@coupon_1.name} coupon was used for this order")

      order = Order.last

      visit profile_orders_path(order)

      expect(page).to have_content("The #{@coupon_1.name} coupon was used for this order")
    end

    it 'Coupons from a merchant only apply to items sold by that merchant, not other items in the cart' do
      within "#item-#{@ogre.id}" do
        expect(page).to have_content('Subtotal: $20.25')
        expect(page).to_not have_content('Subtotal With Discount:')
      end

      within "#item-#{@hippo.id}" do
        expect(page).to have_content('Subtotal: $50.00')
        expect(page).to_not have_content('Subtotal With Discount:')
      end

      within "#coupon-#{@coupon_1.id}" do
        click_button 'Select Coupon'
      end

      within "#item-#{@ogre.id}" do
        expect(page).to have_content('Subtotal: $20.25')
        expect(page).to have_content('Subtotal With Discount: $10.25')
      end

      within "#item-#{@hippo.id}" do
        expect(page).to have_content('Subtotal: $50.00')
        expect(page).to_not have_content('Subtotal With Discount:')
      end
    end

    it 'Cart reflects a discount total for the coupon used' do
      expect(page).to have_content('Total: $70.25')

      within "#coupon-#{@coupon_1.id}" do
        click_button 'Select Coupon'
      end

      expect(page).to have_content('Discount Total: $10.00')

      expect(page).to have_content('Total With Coupon: $60.25')
    end

    it 'If the coupon value is more than the order cost, the total is $0, not a negative number' do
      coupon_4 = @merchant_1.coupons.create!(name: 'Discount 4', discount: 75)

      within "#item-#{@hippo.id}" do
        click_button 'Remove'
      end

      visit cart_path

      within "#coupon-#{coupon_4.id}" do
        click_button 'Select Coupon'
      end

      within "#item-#{@ogre.id}" do
        expect(page).to have_content('Subtotal: $20.25')
        expect(page).to have_content('Subtotal With Discount: $0.00')
      end

      expect(page).to have_content('Total: $20.25')
      expect(page).to have_content('Total With Coupon: $0.00')
    end
  end
end
