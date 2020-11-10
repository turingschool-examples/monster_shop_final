require 'rails_helper'

describe 'As an employee of a merchant' do
  describe 'When I visit the discounts index page' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @user_1 = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @ogre = @merchant_1.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 50 )
      @giant = @merchant_1.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 30 )
      @hippo = @merchant_1.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 100 )
      @discount_1 = @merchant_1.discounts.create!(rate: 5, quantity: 10)
      @discount_2 = @merchant_1.discounts.create!(rate: 10, quantity: 20)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
    end

    it "I see a list of all my discounts" do
      visit '/merchant/discounts'

      expect(page).to have_content("#{@merchant_1.name} Discounts")

      within "#discount-#{@discount_1.id}" do
        expect(page).to have_content("Discount #{@discount_1.id}:")
        expect(page).to have_content("Get #{@discount_1.rate}% off when you purchase #{@discount_1.quantity} or more items")
      end
      within "#discount-#{@discount_2.id}" do
        expect(page).to have_content("Discount #{@discount_2.id}:")
        expect(page).to have_content("Get #{@discount_2.rate}% off when you purchase #{@discount_2.quantity} or more items")
      end
    end
    it "I see each discount as a link and can click that link to go to the discount's show page" do
      visit '/merchant/discounts'

      within "#discount-#{@discount_1.id}" do
        expect(page).to have_link("Discount #{@discount_1.id}:")
      end

      click_link("Discount #{@discount_1.id}:")
      expect(current_path).to eq("/merchant/discounts/#{@discount_1.id}")
    end

    it "I see a link to edit each discount and am taken to the edit discount form" do
      visit '/merchant/discounts'

      within "#discount-#{@discount_1.id}" do
        expect(page).to have_link("Edit Discount")
        click_link("Edit Discount")
      end

      expect(current_path).to eq("/merchant/discounts/#{@discount_1.id}/edit")
    end
    
    xit "I see a link to add a new discount and am taken to the new discount form" do
      visit '/merchant/discounts'

      expect(page).to have_link("New Discount")
      click_link("New Discount")
      expect(current_path).to eq("/merchant/discounts/new")
    end
  end
end
