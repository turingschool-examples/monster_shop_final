require 'rails_helper'

RSpec.describe 'Discount Order Creation' do
  describe 'As a User' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)

      @orge = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )

      @megan_discount_1 = @megan.discounts.create!(description: "Buy 5 items, get 5% off", quantity: 5, percent: 5)
      @megan_discount_2 = @megan.discounts.create!(description: "Buy 10 items, get 25% off", quantity: 10, percent: 25)

      @brian_discount_3 = @brian.discounts.create!(description: "Buy 10 items, get 45% off", quantity: 10, percent: 45)
      @brian_discount_4 = @brian.discounts.create!(description: "Buy 5 items, get 10% off", quantity: 5, percent: 10)
      @brian_discount_5 = @brian.discounts.create!(description: "Buy 6 items, get 30% off", quantity: 6, percent: 30)
      @user = User.create!(name: 'Holly', address: '123 Main St.', city: 'Denver', state: 'CO', zip: 80111)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end
  end 
end
