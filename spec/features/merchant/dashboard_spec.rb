require 'rails_helper'

RSpec.describe 'Merchant Dashboard' do
  describe 'As an employee of a merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @discount1 = @m_user.merchant.discounts.create(percentage: 5, item_amount: 5, description: 'Five percent off of five items or more!')
      @discount2 = @m_user.merchant.discounts.create(percentage: 10, item_amount: 10, description: 'Ten percent off of ten items or more!')
      @discount3 = @m_user.merchant.discounts.create(percentage: 20, item_amount: 20, description: 'Twenty percent off of twenty items or more!')
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
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'I can see my merchants information on the merchant dashboard' do
      visit '/merchant'

      expect(page).to have_link(@merchant_1.name)
      expect(page).to have_content(@merchant_1.address)
      expect(page).to have_content("#{@merchant_1.city} #{@merchant_1.state} #{@merchant_1.zip}")
    end

    it 'I do not have a link to edit the merchant information' do
      visit '/merchant'

      expect(page).to_not have_link('Edit')
    end

    it 'I see a list of pending orders containing my items' do
      visit '/merchant'

      within '.orders' do
        expect(page).to_not have_css("#order-#{@order_1.id}")

        within "#order-#{@order_2.id}" do
          expect(page).to have_link(@order_2.id)
          expect(page).to have_content("Potential Revenue: #{@order_2.merchant_subtotal(@merchant_1.id)}")
          expect(page).to have_content("Quantity of Items: #{@order_2.merchant_quantity(@merchant_1.id)}")
          expect(page).to have_content("Created: #{@order_2.created_at}")
        end

        within "#order-#{@order_3.id}" do
          expect(page).to have_link(@order_3.id)
          expect(page).to have_content("Potential Revenue: #{@order_3.merchant_subtotal(@merchant_1.id)}")
          expect(page).to have_content("Quantity of Items: #{@order_3.merchant_quantity(@merchant_1.id)}")
          expect(page).to have_content("Created: #{@order_3.created_at}")
        end
      end
    end

    it 'I can link to an order show page' do
      visit '/merchant'

      click_link @order_2.id

      expect(current_path).to eq("/merchant/orders/#{@order_2.id}")
    end

    it "I can see a link to discounts" do
      visit '/merchant'

      click_link "Discounts"

      expect(current_path).to eq("/merchant/discounts")
    end

    it "I can click a link to a new discount form" do
      visit '/merchant'

      click_link "Discounts"

      expect(page).to have_link("Create Discount")

      click_link("Create Discount")

      expect(current_path).to eq("/merchant/discounts/new")
    end

    it "I can create a new discount on the new discount form page" do
      @percentage = 5
      @item_amount = 5
      @description = 'Five percent off of five items or more!'
      visit '/merchant'

      click_link "Discounts"

      click_link("Create Discount")

      fill_in 'percentage', with: @percentage
      fill_in 'item_amount', with: @item_amount
      fill_in 'description', with: @description

      click_button 'Create Item'

      expect(current_path).to eq("/merchant/discounts")

      expect(page).to have_content("New discount created!")
      expect(page).to have_content(@percentage)
      expect(page).to have_content(@item_amount)
      expect(page).to have_content(@description)
    end

    it "I can't create a new discount with bad or missing information" do
      @percentage = 5
      @item_amount = 5
      @description = 'Five percent off of five items or more!'
      visit '/merchant'

      click_link "Discounts"

      click_link("Create Discount")

      fill_in 'percentage', with: 120
      fill_in 'description', with: @description

      click_button 'Create Item'

      expect(current_path).to eq("/merchant/discounts/new")
      expect(page).to have_content("Item amount can't be blank")
      expect(page).to have_content("Percentage must be less than 100")
    end

    it "I can edit an existing discount" do

      visit '/merchant'

      click_link "Discounts"

      within ".discounts-#{@discount1.id}" do
        expect(page).to have_content('Edit Discount')
        click_link "Edit Discount"
      end

      expect(current_path).to eq("/merchant/discounts/#{@discount1.id}/edit")

      expect(find_field('Percentage').value).to eq '5'
      expect(find_field('Item amount').value).to eq '5'
      expect(find_field('Description').value).to eq 'Five percent off of five items or more!'

      fill_in :percentage, with: 6
      fill_in :item_amount, with: 4
      fill_in :description, with: 'Six percent off of four items or more!?'
      click_button "Update Discount"

      expect(current_path).to eq("/merchant/discounts")
      expect(page).to have_content("Discount Updated")
      expect(page).to_not have_content("Description: 'Five percent off of five items or more!'")
      expect(page).to_not have_content("Item amount: 5")
      expect(page).to_not have_content("Percentage: 5")
      expect(page).to have_content("Description: Six percent off of four items or more!?")
      expect(page).to have_content("Item amount: 4")
      expect(page).to have_content("Percentage: 6")
    end

    it "I cannot edit an existing discount with bad or missing information" do
      visit '/merchant'

      click_link "Discounts"

      within ".discounts-#{@discount1.id}" do
        expect(page).to have_content('Edit Discount')
        click_on 'Edit Discount'
      end

      expect(find_field('Percentage').value).to eq '5'
      expect(find_field('Item amount').value).to eq '5'
      expect(find_field('Description').value).to eq 'Five percent off of five items or more!'

      fill_in :percentage, with: 120
      fill_in :item_amount, with: 0
      click_button "Update Discount"
      expect(current_path).to eq("/merchant/discounts/#{@discount1.id}/edit")
      expect(page).to have_content("Percentage must be less than 100")
      expect(page).to have_content("Item amount must be greater than 0")
    end

    it "I can delete a discount" do
      visit '/merchant'

      click_link "Discounts"

      within ".discounts-#{@discount1.id}" do
        expect(page).to have_content('Delete Discount')
        click_on 'Delete Discount'
      end

      expect(current_path).to eq("/merchant/discounts")
      expect(page).to_not have_content(@discount1.description)
      expect(page).to_not have_content(@discount1.percentage)
      expect(page).to_not have_content(@discount1.item_amount)
    end
  end
end
