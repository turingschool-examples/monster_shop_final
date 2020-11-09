require 'rails_helper'

RSpec.describe CartConcern do
  describe 'class methods' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @megan_discount_1 = @megan.discounts.create!(description: "Buy 5 items, get 5% off", quantity: 5, percent: 5)
      @megan_discount_2 = @megan.discounts.create!(description: "Buy 10 items, get 25% off", quantity: 10, percent: 25)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @cart = Cart.new(Hash.new)
      @quantity_1 = @megan_discount_1.quantity
      @quantity_2 = @megan_discount_2.quantity

    end

    it 'finds the merchant' do
      expect(@cart.find_merchant(@ogre.id)).to eq(@megan)
    end

    it 'finds the item' do
      expect(@cart.find_item(@ogre.id)).to eq(@ogre)
    end

    it 'checks if there are discounts that belong to a merchant' do
      expect(@cart.empty_merchant_discount?(@ogre.id)).to eq(true)
    end

    it 'calculates percentage' do
      expect(@cart.percentage(@megan_discount_1)).to eq(0.95)
    end

    it 'calculates the largest discount' do
      expect(@cart.all_available_discounts(@ogre, @quantity_1)).to eq(@megan_discount_1)
      expect(@cart.all_available_discounts(@ogre, @quantity_2)).to eq(@megan_discount_2)
    end
  end
end
