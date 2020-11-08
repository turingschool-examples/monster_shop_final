require 'rails_helper'

describe Discount do
  describe 'relationships' do
    it {should belong_to(:item)}
    it {should belong_to(:merchant)}
  end

  describe 'validations' do
    it {should validate_presence_of :item_id}
    it {should validate_presence_of :merchant_id}
    it {should validate_presence_of :threshold}
    it {should validate_presence_of :discount}
  end

  describe 'class methods' do
    it '.item_discount' do
      megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      ogre = megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 10, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      giant = megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 2 )
           
      m1_discount1 = megan.discounts.create!(item_id: ogre.id, threshold: 5, discount: 0.1)
      m1_discount1 = megan.discounts.create!(item_id: ogre.id, threshold: 5, discount: 0.05)
      m1_discount2 = megan.discounts.create!(item_id: ogre.id, threshold: 10, discount: 0.25)

      order_quantity = 4
      expect(Discount.item_discount(ogre.id, ogre.merchant_id, ogre.price, order_quantity)).to eq(0)

      order_quantity = 5
      expect(Discount.item_discount(ogre.id, ogre.merchant_id, ogre.price, order_quantity).round(2)).to eq(5)

      order_quantity = 12
      expect(Discount.item_discount(ogre.id, ogre.merchant_id, ogre.price, order_quantity).round(2)).to eq(30)
      
      expect(Discount.item_discount(giant.id, giant.merchant_id, giant.price, order_quantity)).to eq(0)
    end
  end
end
