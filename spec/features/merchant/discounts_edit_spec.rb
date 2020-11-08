require 'rails_helper'

describe 'As a merchant employee' do
  before :each do
    @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
    @merchant_2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
    @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
    @ogre = @merchant_1.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 100 )
    @giant = @merchant_1.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 200 )
    @hippo = @merchant_2.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 300 )
    @order_1 = @m_user.orders.create!(status: "pending")
    @order_2 = @m_user.orders.create!(status: "pending")
    @order_3 = @m_user.orders.create!(status: "pending")
    @order_item_1 = @order_1.order_items.create!(item: @hippo, price: @hippo.price, quantity: 2, fulfilled: false)
    @order_item_2 = @order_2.order_items.create!(item: @hippo, price: @hippo.price, quantity: 2, fulfilled: true)
    @order_item_3 = @order_2.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: false)
    @order_item_4 = @order_3.order_items.create!(item: @giant, price: @giant.price, quantity: 2, fulfilled: false)

    #discounts
    @m1_discount1 = @merchant_1.discounts.create!(item_id: @ogre.id, threshold: 5, discount: 0.1)
    @m1_discount2 = @merchant_1.discounts.create!(item_id: @ogre.id, threshold: 10, discount: 0.15)
    @m1_discount3 = @merchant_1.discounts.create!(item_id: @giant.id, threshold: 20, discount: 0.20)
    @m2_discount1 = @merchant_2.discounts.create!(item_id: @hippo.id, threshold: 10, discount: 0.5)
  
    visit '/login'
    fill_in 'email', with: "#{@m_user.email}"
    fill_in 'password', with: "#{@m_user.password}"
    click_button('Log In')

  end
  describe 'when I edit a discount record' do
    before :each do
      visit "/merchant/discounts/#{@m1_discount1.id}/edit"
    end
    it "I see a form to discount's item, threshold, and discount rate" do
      expect(page).to have_field("discount[item_id]")
      expect(page).to have_field("discount[threshold]")
      expect(page).to have_field("discount[discount]")
    end
    it "once I click update, I'm redirected to the merchant/discounts page and see my updated discount record" do
      fill_in "discount[threshold]", with: 50
      click_on("Update Discount")
      expect(current_path).to eq("/merchant/discounts")
      within ("#discount-#{@m1_discount1.id}") do
        expect(page).to have_content("Threshold: 50")
      end
    end

    it "if I don't fill in all the fields on the form I'm redirected to form page and asked to fill in all details" do
      select('Ogre', from: 'discount[item_id]')
      fill_in "discount[threshold]", with: nil
      click_on("Update Discount")
      expect(page).to have_field("discount_threshold")
      expect(page).to have_content("Threshold can't be blank")
    end

    it "the discount must be between 0 and 1, and the threshold must be greater than 0" do
      select('Ogre', from: 'discount[item_id]')
      fill_in "discount[threshold]", with: -10
      fill_in "discount[discount]", with: 3
      click_on("Update Discount")
      expect(page).to have_field("discount_threshold")
      expect(page).to have_content("Threshold must be greater than 0 and Discount must be less than 1")
      
      fill_in "discount[threshold]", with: 5
      fill_in "discount[discount]", with: -2
      click_on("Update Discount")
      expect(page).to have_field("discount_threshold")
      expect(page).to have_content("Discount must be greater than 0")
    end


  end
end
