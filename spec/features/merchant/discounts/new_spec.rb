require 'rails_helper'

RSpec.describe 'Discounts Creation' do
  describe 'As a Merchant Employee' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_user = @megan.users.create!(name: "Hope", address: "456 Space st", city: "Space", state: "CO", zip: 80111, email: "Hope@example.com", password: "superEasyPZ", role: 1)
      @orge = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @order_1 = @merchant_user.orders.create!(status: 'pending')
      @order_2 = @merchant_user.orders.create!(status: 'pending')
      @order_3 = @merchant_user.orders.create!(status: 'pending')
      @order_4 = @merchant_user.orders.create!(status: 'pending')
      @order_item_1 = @order_1.order_items.create!(item: @orge, price: @orge.price, quantity: 3, fulfilled: false)
      @order_item_2 = @order_2.order_items.create!(item: @giant, price: @giant.price, quantity: 4, fulfilled: false)
      @order_item_3 = @order_3.order_items.create!(item: @hippo, price: @hippo.price, quantity: 3, fulfilled: false)
      @order_item_4 = @order_4.order_items.create!(item: @hippo, price: @orge.price, quantity: 4, fulfilled: false)
      @order_item_5 = @order_1.order_items.create!(item: @giant, price: @giant.price, quantity: 3, fulfilled: true)
      @order_item_6 = @order_2.order_items.create!(item: @orge, price: @orge.price, quantity: 4, fulfilled: true)
      @megan_discount_1 = @megan.discounts.create!(description: 'Buy 5 items, get 5% off', quantity: 5, percent: 5)
      @megan_discount_2 = @megan.discounts.create!(description: 'Buy 10 items, get 25% off', quantity: 10, percent: 25)
      @brian_discount_3 = @brian.discounts.create!(description: 'Buy 10 items, get 45% off', quantity: 10, percent: 45)
      @brian_discount_4 = @brian.discounts.create!(description: 'Buy 5 items, get 10% off', quantity: 5, percent: 10)
      @brian_discount_5 = @brian.discounts.create!(description: 'Buy 6 items, get 30% off', quantity: 6, percent: 30)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
    end

    it 'can navigate to a page to create a new discount' do
      visit '/merchant'

      expect(page).to have_content('All My Orders')
      expect(page).to have_link('My Discounts')
      click_link 'My Discounts'
      expect(current_path).to eq('/merchant/discounts')

      expect(page).to have_link('Create New Discount')
      click_link 'Create New Discount'
      expect(current_path).to eq('/merchant/discounts/new')

      expect(page).to have_content('Create A New Discount')
      fill_in :description, with: @megan_discount_1.description
      fill_in :quantity, with: @megan_discount_1.quantity
      fill_in :percent, with: @megan_discount_1.percent

      click_on 'Submit Discount'

      expect(current_path).to eq('/merchant/discounts')
      expect(page).to have_content('Hooray! You created a new discount!')
      last_discount = Discount.last

      expect(page).to have_content('All My Discounts')
      within "#discounts-#{@megan_discount_1.id}" do
        expect(page).to have_content("Description of Discount: #{@megan_discount_1.description}")
        expect(page).to have_content("Discount ID: ##{@megan_discount_1.id}")
        expect(page).to have_link("#{@megan_discount_1.id}")
      end
    end

    it 'must fill out the new discount form completely, or the employee will be given a flash message and a renew path' do
      visit '/merchant/discounts'

      expect(page).to have_link('Create New Discount')
      click_link 'Create New Discount'
      expect(current_path).to eq('/merchant/discounts/new')

      expect(page).to have_content('Create A New Discount')
      fill_in :description, with: @megan_discount_1.description
      fill_in :quantity, with: ''
      fill_in :percent, with: @megan_discount_1.percent

      click_on 'Submit Discount'

      expect(current_path).to eq('/merchant/discounts')
      expect(page).to have_content('You must fill out all fields to create this discount. Try again')

    end

    it 'can have more than one discount enabled' do
      visit '/merchant/discounts'

      click_link 'Create New Discount'
      expect(current_path).to eq('/merchant/discounts/new')

      expect(page).to have_content('Create A New Discount')
      fill_in :description, with: @megan_discount_1.description
      fill_in :quantity, with: @megan_discount_1.quantity
      fill_in :percent, with: @megan_discount_1.percent

      click_on 'Submit Discount'
      expect(current_path).to eq('/merchant/discounts')

      within "#discounts-#{@megan_discount_1.id}" do
        expect(page).to have_content("Description of Discount: #{@megan_discount_1.description}")
        expect(page).to have_content("Discount ID: ##{@megan_discount_1.id}")
        expect(page).to have_link("#{@megan_discount_1.id}")
      end

      click_link 'Create New Discount'
      expect(current_path).to eq('/merchant/discounts/new')

      expect(page).to have_content('Create A New Discount')
      fill_in :description, with: @megan_discount_2.description
      fill_in :quantity, with: @megan_discount_2.quantity
      fill_in :percent, with: @megan_discount_2.percent

      click_on 'Submit Discount'
      expect(current_path).to eq('/merchant/discounts')

      within "#discounts-#{@megan_discount_2.id}" do
        expect(page).to have_content("Description of Discount: #{@megan_discount_2.description}")
        expect(page).to have_content("Discount ID: ##{@megan_discount_2.id}")
        expect(page).to have_link("#{@megan_discount_2.id}")
      end
    end
  end
end
