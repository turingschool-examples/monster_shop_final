require 'rails_helper'

RSpec.describe Discount do
  describe 'Relationships' do
    it {should belong_to(:merchant)}
  end

  describe 'Instance Methods' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @discount_1 = @megan.discounts.create(name: '5 Percent', percentage: 0.05, limit: 5)
      @discount_2 = @megan.discounts.create(name: '10 Percent', percentage: 0.1, limit: 10)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 20 )
    end
    it ".discount_rates(arg)"do
      discounts = @ogre.available_discounts

      expect(discounts.discount_rate(4)).to eq(nil)
      expect(discounts.discount_rate(5)).to eq(@discount_1)
      expect(discounts.discount_rate(9)).to eq(@discount_1)
      expect(discounts.discount_rate(10)).to eq(@discount_2)
    end
  end
end
