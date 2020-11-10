require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Cart Discounts' do
  describe 'As a Visitor' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @merchant_1.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @merchant_1.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      # @user_1 = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @discount_1 = @merchant_1.discounts.create!(rate: 5, quantity: 4)

      # allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
    end
    describe "When I add enough of a single item" do
      before :each do
        4.times do
          visit "/items/#{@ogre.id}"
          click_button('Add to Cart')
        end

        visit "/items/#{@giant.id}"
        click_button('Add to Cart')

        2.times do
          visit "/items/#{@hippo.id}"
          click_button('Add to Cart')
        end
      end
      it "I see the discount automatically shows up in my cart" do
        visit '/cart'

        within "#item-#{@ogre.id}" do
          expect(page).to have_content()
        end
      end

      xit "I don't see a discount applied to other items from that merchant" do
        visit '/cart'

      end

      xit "I don't see a discount applied to items from other merchants" do
        visit '/cart'

      end
    end
  end
end
