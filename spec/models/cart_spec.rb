require 'rails_helper'

RSpec.describe Cart do
  describe 'Instance Methods' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 2 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @discount = @brian.discounts.create!(description: 'Buy 5 items, get 5% off', quantity: 5, percent: 5)
      @cart_1 = Cart.new({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2
        })
      @cart_2 = Cart.new({
        @hippo.id.to_s => 3
        })
    end

    it '.contents' do
      expect(@cart_1.contents).to eq({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2
        })
    end

    it '.add_item()' do
      @cart_1.add_item(@hippo.id.to_s)

      expect(@cart_1.contents).to eq({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2,
        @hippo.id.to_s => 1
        })
    end

    it '.count' do
      expect(@cart_1.count).to eq(3)
    end

    it '.items' do
      expect(@cart_1.items).to eq([@ogre, @giant])
    end

    it '.grand_total' do
      expect(@cart_1.grand_total).to eq(120)
    end

    it '.count_of()' do
      expect(@cart_1.count_of(@ogre.id)).to eq(1)
      expect(@cart_1.count_of(@giant.id)).to eq(2)
    end

    it '.subtotal_of()' do
      expect(@cart_1.subtotal_of(@ogre.id)).to eq(20)
      expect(@cart_1.subtotal_of(@giant.id)).to eq(100)
    end

    it '.limit_reached?()' do
      expect(@cart_1.limit_reached?(@ogre.id)).to eq(false)
      expect(@cart_1.limit_reached?(@giant.id)).to eq(true)
    end

    it '.less_item()' do
      @cart_1.less_item(@giant.id.to_s)

      expect(@cart_1.count_of(@giant.id)).to eq(1)
    end

    xit '.new_cart_discounts()' do
      expect(@cart_2.new_cart_discounts(@discount, 250)).to eq(237.5)
    end

    xit 'find_merchant()' do
      expect(find_merchant(@ogre.id)).to eq(@megan)
    end

    xit '#find_item()' do
      expect(find_item(@giant.id)).to eq(@giant)
    end

    xit '.empty_merchant_discount?()' do
      expect().to eq()
    end

    # updated
    it '.grand_total' do
      expect(@cart_2.contents).to eq({@hippo.id.to_s => 3})
      expect(@cart_2.grand_total).to eq(150)
      @cart_2.add_item(@hippo.id.to_s)
      @cart_2.add_item(@hippo.id.to_s)
      expect(@cart_2.grand_total).to eq(237.5)
    end

    it '.show_discounts()' do
      expect(@cart_2.show_discounts(@hippo.id)).to eq('Buy 5 items, get 5% off')
      expect(@cart_1.show_discounts(@ogre.id)).to eq('There are no discounts available at this moment')

      @cart_2.add_item(@hippo.id.to_s)
      @cart_2.add_item(@hippo.id.to_s)
      expect(@cart_2.show_discounts(@hippo.id)).to eq('Wahoo! You qualify for a bulk discount!')
    end

    it '.discount_criteria_met?()' do
      expect(@cart_2.discount_criteria_met?(@hippo, 7)).to eq(true)
    end

    xit '.all_available_discounts()' do
      expect().to eq()
    end

    xit 'percentage()' do
      # binding.pry
      expect(percentage(@discount)).to eq(0.05)
      # expect(((100 - @discount.percent).to_f )/ 100).to eq(0.05)
    end
  end
end
