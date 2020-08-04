require 'rails_helper'

RSpec.describe Cart do
  describe 'Instance Methods' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @megan.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @discount1 = @m_user.merchant.discounts.create(percentage: 5, item_amount: 5, description: 'Five percent off of five items or more!')
      @discount2 = @m_user.merchant.discounts.create(percentage: 20, item_amount: 10, description: 'Fifteen percent off of ten items or more!')
      @discount3 = @m_user.merchant.discounts.create(percentage: 15, item_amount: 9, description: 'Fifteen percent off of nine items or more!')
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 2 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @candle = @megan.items.create!(name: 'Candle', description: "I'll light up your life!", price: 5, image: 'https://cf.ltkcdn.net/candles/images/orig/257384-1600x1030-white-candle-magic-spells.jpg', active: true, inventory: 30 )
      @dish_towel = @megan.items.create!(name: 'Dish Towel', description: "I'll clean it up!", price: 10, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSKTzwz1piuGJO5B0aUlunlY9LCM0wVP1wkag&usqp=CAU', active: true, inventory: 100 )
      @everyting = @brian.items.create!(name: 'Everything Bagel', description: "I've got anything you want!", price: 12, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQos5CbFANK1ZNGcqT-DycLcspuLqxqfRLRNE-HEYkqYKy88NOu8HjTeiGuiFyq5c7kxEIsmuX6&usqp=CAc', active: true, inventory: 100 )
      @cart = Cart.new({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2
        })
      @cart2 = Cart.new({
        @ogre.id.to_s => 4,
        @giant.id.to_s => 2,
        @candle.id.to_s => 5
        })
    end

    it '.contents' do
      expect(@cart.contents).to eq({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2
        })
    end

    it '.add_item()' do
      @cart.add_item(@hippo.id.to_s)

      expect(@cart.contents).to eq({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2,
        @hippo.id.to_s => 1
        })
    end

    it '.count' do
      expect(@cart.count).to eq(3)
    end

    it '.items' do
      expect(@cart.items).to eq([@ogre, @giant])
    end
    #discount
    it '.grand_total' do
      expect(@cart.grand_total).to eq(120)
      expect(@cart2.grand_total).to eq(203.75)
    end
    #discount
    it '.count_of()' do
      expect(@cart.count_of(@ogre.id)).to eq(1)
      expect(@cart.count_of(@giant.id)).to eq(2)
    end
    #discount
    it '.subtotal_of()' do

      expect(@cart.subtotal_of(@ogre.id)).to eq(20)
      expect(@cart.subtotal_of(@giant.id)).to eq(100)
      expect(@cart2.subtotal_of(@candle.id)).to eq(23.75)
    end

    it '.limit_reached?()' do
      expect(@cart.limit_reached?(@ogre.id)).to eq(false)
      expect(@cart.limit_reached?(@giant.id)).to eq(true)
    end

    it '.less_item()' do
      @cart.less_item(@giant.id.to_s)

      expect(@cart.count_of(@giant.id)).to eq(1)
    end

    it ".discount_eligible?()" do
      expect(@cart2.discount_eligible?(@ogre.id)).to eq(nil)
      expect(@cart2.discount_eligible?(@giant.id)).to eq(nil)
      expect(@cart2.discount_eligible?(@candle.id)).to eq(@discount1)
      @cart2.add_item(@ogre.id.to_s)
      expect(@cart2.discount_eligible?(@ogre.id)).to eq(@discount1)
      @cart2.add_item(@candle.id.to_s)
      @cart2.add_item(@candle.id.to_s)
      @cart2.add_item(@candle.id.to_s)
      @cart2.add_item(@candle.id.to_s)
      expect(@cart2.discount_eligible?(@candle.id)).to eq(@discount3)
      @cart2.add_item(@candle.id.to_s)
      expect(@cart2.discount_eligible?(@candle.id)).to eq(@discount2)
      @cart2.add_item(@everyting.id.to_s)
      @cart2.add_item(@everyting.id.to_s)
      @cart2.add_item(@everyting.id.to_s)
      @cart2.add_item(@everyting.id.to_s)
      @cart2.add_item(@everyting.id.to_s)
      expect(@cart2.discount_eligible?(@everyting.id)).to eq(nil)
    end
  end
end
