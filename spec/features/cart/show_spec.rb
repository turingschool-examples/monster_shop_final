require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Cart Show Page' do
  describe 'As a Visitor' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
    end

    describe 'I can see my cart' do
      it "I can visit a cart show page to see items in my cart" do
        visit item_path(@ogre)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'

        visit '/cart'

        expect(page).to have_content("Total: #{number_to_currency((@ogre.price * 1) + (@hippo.price * 2))}")

        within "#item-#{@ogre.id}" do
          expect(page).to have_link(@ogre.name)
          expect(page).to have_content("Price: #{number_to_currency(@ogre.price)}")
          expect(page).to have_content("Quantity: 1")
          expect(page).to have_content("Subtotal: #{number_to_currency(@ogre.price * 1)}")
          expect(page).to have_content("Sold by: #{@megan.name}")
          expect(page).to have_css("img[src*='#{@ogre.image}']")
          expect(page).to have_link(@megan.name)
        end

        within "#item-#{@hippo.id}" do
          expect(page).to have_link(@hippo.name)
          expect(page).to have_content("Price: #{number_to_currency(@hippo.price)}")
          expect(page).to have_content("Quantity: 2")
          expect(page).to have_content("Subtotal: #{number_to_currency(@hippo.price * 2)}")
          expect(page).to have_content("Sold by: #{@brian.name}")
          expect(page).to have_css("img[src*='#{@hippo.image}']")
          expect(page).to have_link(@brian.name)
        end
      end

      it "I can visit an empty cart page" do
        visit '/cart'

        expect(page).to have_content('Your Cart is Empty!')
        expect(page).to_not have_button('Empty Cart')
      end
    end

    describe 'I can manipulate my cart' do
      it 'I can empty my cart' do
        visit item_path(@ogre)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'

        visit '/cart'

        click_button 'Empty Cart'

        expect(current_path).to eq('/cart')
        expect(page).to have_content('Your Cart is Empty!')
        expect(page).to have_content('Cart: 0')
        expect(page).to_not have_button('Empty Cart')
      end

      it 'I can remove one item from my cart' do
        visit item_path(@ogre)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'

        visit '/cart'

        within "#item-#{@hippo.id}" do
          click_button('Remove')
        end

        expect(current_path).to eq('/cart')
        expect(page).to_not have_content("#{@hippo.name}")
        expect(page).to have_content('Cart: 1')
        expect(page).to have_content("#{@ogre.name}")
      end

      it 'I can add quantity to an item in my cart' do
        visit item_path(@ogre)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'

        visit '/cart'

        within "#item-#{@hippo.id}" do
          click_button('More of This!')
        end

        expect(current_path).to eq('/cart')
        within "#item-#{@hippo.id}" do
          expect(page).to have_content('Quantity: 3')
        end
      end

      it 'I can not add more quantity than the items inventory' do
        visit item_path(@hippo)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'

        visit '/cart'

        within "#item-#{@hippo.id}" do
          expect(page).to_not have_button('More of This!')
        end

        visit "/items/#{@hippo.id}"

        click_button 'Add to Cart'

        expect(page).to have_content("You have all the item's inventory in your cart already!")
      end

      it 'I can reduce the quantity of an item in my cart' do
        visit item_path(@hippo)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'

        visit '/cart'

        within "#item-#{@hippo.id}" do
          click_button('Less of This!')
        end

        expect(current_path).to eq('/cart')
        within "#item-#{@hippo.id}" do
          expect(page).to have_content('Quantity: 2')
        end
      end

      it 'if I reduce the quantity to zero, the item is removed from my cart' do
        visit item_path(@hippo)
        click_button 'Add to Cart'

        visit '/cart'

        within "#item-#{@hippo.id}" do
          click_button('Less of This!')
        end

        expect(current_path).to eq('/cart')
        expect(page).to_not have_content("#{@hippo.name}")
        expect(page).to have_content("Cart: 0")
      end

      it "I add the minimum quantity of an item for a bulk discount and I see the discount reflected in my subtotal" do
        discount_1 = @megan.discounts.create(percent: 5, quantity: 3)
        visit item_path(@ogre)
        click_button 'Add to Cart'
        visit item_path(@ogre)
        click_button 'Add to Cart'

        visit '/cart'
        expect(page).to have_content("Cart: 2")
        expect(page).to have_content("Total: $40.00")

        within "#item-#{@ogre.id}" do
          expect(page).to_not have_content("Discount Applied: #{discount_1.quantity} items at #{number_to_percentage(discount_1.percent, strip_insignificant_zeros: true)} off")
          expect(page).to have_content("Subtotal: $40.00")
        end

        visit item_path(@ogre)
        click_button 'Add to Cart'
        visit item_path(@ogre)
        click_button 'Add to Cart'
        visit item_path(@ogre)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'

        visit '/cart'

        expect(page).to have_content("Cart: 6")
        expect(page).to have_content("Total: $145.00")

        within "#item-#{@ogre.id}" do
          expect(page).to have_content("Discount Applied: #{discount_1.quantity} items at #{number_to_percentage(discount_1.percent, strip_insignificant_zeros: true)} off")
          expect(page).to have_content("Subtotal: $95.00")
        end
      end

      it "If I remove items and do not have enough quantity for a discount I no longer see the bulk discount" do
        discount_1 = @megan.discounts.create(percent: 5, quantity: 3)
        visit item_path(@ogre)
        click_button 'Add to Cart'
        visit item_path(@ogre)
        click_button 'Add to Cart'
        visit item_path(@ogre)
        click_button 'Add to Cart'
        visit item_path(@ogre)
        click_button 'Add to Cart'
        visit item_path(@ogre)
        click_button 'Add to Cart'

        visit '/cart'

        within "#item-#{@ogre.id}" do
          expect(page).to have_content("Discount Applied: #{discount_1.quantity} items at #{number_to_percentage(discount_1.percent, strip_insignificant_zeros: true)} off")
          expect(page).to have_content("Subtotal: $95.00")
          click_button ('Less of This!')
          click_button ('Less of This!')
          click_button ('Less of This!')
        end

        expect(page).to have_content("Cart: 2")
        expect(page).to have_content("Total: $40.00")

        within "#item-#{@ogre.id}" do
          expect(page).to_not have_content("Discount Applied: #{discount_1.quantity} items at #{number_to_percentage(discount_1.percent, strip_insignificant_zeros: true)} off")
          expect(page).to have_content("Subtotal: $40.00")
        end
      end

      it "I can add discounts from multiple merchants" do
        discount_1 = @megan.discounts.create(percent: 5, quantity: 3)
        discount_2 = @brian.discounts.create(percent: 4, quantity: 2)

        visit item_path(@ogre)
        click_button 'Add to Cart'
        visit item_path(@ogre)
        click_button 'Add to Cart'
        visit item_path(@ogre)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'

        visit '/cart'
        expect(page).to have_content("Cart: 5")
        expect(page).to have_content("Total: $153.00")

        within "#item-#{@ogre.id}" do
          expect(page).to have_content("Discount Applied: #{discount_1.quantity} items at #{number_to_percentage(discount_1.percent, strip_insignificant_zeros: true)} off")
          expect(page).to have_content("Subtotal: $57.00")
        end

        within "#item-#{@hippo.id}" do
          expect(page).to have_content("Discount Applied: #{discount_2.quantity} items at #{number_to_percentage(discount_2.percent, strip_insignificant_zeros: true)} off")
          expect(page).to have_content("Subtotal: $96.00")
        end
      end

      it "I can add multiple discounts from the same merchant for different items" do
        discount_1 = @megan.discounts.create(percent: 5, quantity: 3)
        vampire = @megan.items.create!(name: 'Vampire', description: "I'm a Vampire!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )

        visit item_path(@ogre)
        click_button 'Add to Cart'
        visit item_path(@ogre)
        click_button 'Add to Cart'
        visit item_path(@ogre)
        click_button 'Add to Cart'
        visit item_path(@giant)
        click_button 'Add to Cart'
        visit item_path(@giant)
        click_button 'Add to Cart'
        visit item_path(@giant)
        click_button 'Add to Cart'
        visit item_path(vampire)
        click_button 'Add to Cart'

        visit '/cart'

        expect(page).to have_content("Cart: 7")
        expect(page).to have_content("Total: $249.50")

        within "#item-#{@ogre.id}" do
          expect(page).to have_content("Discount Applied: #{discount_1.quantity} items at #{number_to_percentage(discount_1.percent, strip_insignificant_zeros: true)} off")
          expect(page).to have_content("Subtotal: $57.00")
        end

        within "#item-#{@giant.id}" do
          expect(page).to have_content("Discount Applied: #{discount_1.quantity} items at #{number_to_percentage(discount_1.percent, strip_insignificant_zeros: true)} off")
          expect(page).to have_content("Subtotal: $142.50")
        end

        within "#item-#{vampire.id}" do
          expect(page).to_not have_content("Discount Applied: #{discount_1.quantity} items at #{number_to_percentage(discount_1.percent, strip_insignificant_zeros: true)} off")
          expect(page).to have_content("Subtotal: $50.00")
        end
      end

      it "When there is a conflict between discounts the greater discount will apply" do
        discount_1 = @megan.discounts.create(percent: 2, quantity: 5)
        discount_2 = @megan.discounts.create(percent: 5, quantity: 7)
        discount_3 = @megan.discounts.create(percent: 15, quantity: 5, status: 'inactive')
        vampire = @megan.items.create!(name: 'Vampire', description: "I'm a Vampire!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 20)

        visit item_path(vampire)
        click_button 'Add to Cart'
        visit item_path(vampire)
        click_button 'Add to Cart'
        visit item_path(vampire)
        click_button 'Add to Cart'
        visit item_path(vampire)
        click_button 'Add to Cart'
        visit item_path(vampire)
        click_button 'Add to Cart'
        visit item_path(vampire)
        click_button 'Add to Cart'
        visit item_path(vampire)
        click_button 'Add to Cart'

        visit '/cart'

        expect(page).to have_content("Cart: 7")
        expect(page).to have_content("Total: $332.50")

        within "#item-#{vampire.id}" do
          expect(page).to have_content("Discount Applied: #{discount_2.quantity} items at #{number_to_percentage(discount_2.percent, strip_insignificant_zeros: true)} off")
          expect(page).to have_content("Subtotal: $332.50")
        end
      end

      it "I see my total savings in the cart" do
        discount_1 = @megan.discounts.create(percent: 5, quantity: 3)
        visit item_path(@ogre)
        click_button 'Add to Cart'
        visit item_path(@ogre)
        click_button 'Add to Cart'
        visit item_path(@ogre)
        click_button 'Add to Cart'

        visit '/cart'
        expect(page).to have_content("Cart: 3")
        expect(page).to have_content("Total: $57.00")

        within "#item-#{@ogre.id}" do
          expect(page).to have_content("Discount Applied: #{discount_1.quantity} items at #{number_to_percentage(discount_1.percent, strip_insignificant_zeros: true)} off")
          expect(page).to have_content("You saved $3.00!")
          expect(page).to have_content("Subtotal: $57.00")
        end
      end

      it "I see the discounted prices for each item" do
        discount_1 = @megan.discounts.create(percent: 5, quantity: 3)
        visit item_path(@ogre)
        click_button 'Add to Cart'
        visit item_path(@ogre)
        click_button 'Add to Cart'
        visit item_path(@ogre)
        click_button 'Add to Cart'

        visit '/cart'
        expect(page).to have_content("Total: $57.00")

        within "#item-#{@ogre.id}" do
          expect(page).to have_content("Price: $19.00")
        end
      end
    end
  end
end
