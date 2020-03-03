require 'rails_helper'

RSpec.describe 'Cart' do
  describe 'As a visitor' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Creatures', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_2 = Merchant.create!(name: 'Brians Animals', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_3 = Merchant.create!(name: 'Bettys Heros', address: '127 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @ogre = @merchant_1.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 10, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 100 )
      @giant = @merchant_1.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 100 )
      @hippo = @merchant_2.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 100 )
      @panda = @merchant_2.items.create!(name: 'Panda', description: "I'm a Panda!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 100 )
      @aquaman = @merchant_3.items.create!(name: 'Aquaman', description: "I'm Aquaman!", price: 35, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 100 )
      @discount1 = @merchant_1.discounts.create!(percent_off: 5, quantity_threshold: 2, status: "active")
      @discount2 = @merchant_1.discounts.create!(percent_off: 10, quantity_threshold: 4, status: "active")
      @discount3 = @merchant_2.discounts.create!(percent_off: 15, quantity_threshold: 6, status: "inactive")
      @discount4 = @merchant_2.discounts.create!(percent_off: 15, quantity_threshold: 8, status: "active")
    end

    it "I can add items and see the discount applied as the quantity reaches a threshold" do
      visit item_path(@ogre)

      click_button 'Add to Cart'

      expect(page).to have_content("#{@ogre.name} has been added to your cart!")
      expect(page).to have_content("Cart: 1")

      visit "/cart"

      within "#item-#{@ogre.id}" do
        expect(page).to have_link(@ogre.name)
        expect(page).to have_content("Price: $10.00")
        expect(page).to have_content("Quantity: 1")
        expect(page).to have_content("Bulk Discounts Available: 2")
        expect(page).to have_content("Save 5% when you buy 2 or more")
        expect(page).to have_content("Save 10% when you buy 4 or more")
        expect(page).to have_content("Subtotal: $10.00")
      end

      click_button 'More of This!'

      within "#item-#{@ogre.id}" do
        expect(page).to have_link(@ogre.name)
        expect(page).to have_content("Price: $10.00")
        expect(page).to have_content("Quantity: 2")
        expect(page).to have_content("Bulk Discounts Available: 2")
        expect(page).to have_content("Save 5% when you buy 2 or more")
        expect(page).to have_content("Save 10% when you buy 4 or more")
        expect(page).to have_content("Subtotal: $19.00")
      end
    end

    xit "discounts only apply to items whose merchants have discounts and who's quantity meets threshold" do
      visit item_path(@ogre)
      click_button 'Add to Cart'
      expect(page).to have_content("Cart: 1")

      visit item_path(@giant)
      click_button 'Add to Cart'
      expect(page).to have_content("Cart: 2")

      visit item_path(@aquaman)
      click_button 'Add to Cart'
      expect(page).to have_content("Cart: 3")

      visit "/cart"

      within "#item-#{@ogre.id}" do
        click_button 'More of This!'
      end

      within "#item-#{@aquaman.id}" do
        click_button 'More of This!'
      end
    end

  end
end
