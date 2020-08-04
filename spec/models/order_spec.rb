require 'rails_helper'

RSpec.describe Order do
  describe 'relationships' do
    it {should have_many :order_items}
    it {should have_many(:items).through(:order_items)}
    it {should belong_to :user}
  end

  describe 'instance methods' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @user = User.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan_1@example.com', password: 'securepassword')
      @order_1 = @user.orders.create!(status: "packaged")
      @order_2 = @user.orders.create!(status: "pending")
      @order_item_1 = @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 5, fulfilled: true)
      @order_item_2 = @order_2.order_items.create!(item: @hippo, price: @hippo.price, quantity: 2, fulfilled: true)
      @order_item_3 = @order_2.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: false)
    end

    it '.grand_total' do
      expect(@order_1.grand_total).to eq(101.25)
      expect(@order_2.grand_total).to eq(140.5)
    end

    it '.count_of_items' do
      expect(@order_1.count_of_items).to eq(5)
      expect(@order_2.count_of_items).to eq(4)
    end

    it '.cancel' do
      @order_2.cancel

      @order_2.reload

      expect(@order_2.status).to eq('cancelled')
      @order_2.order_items.each do |order_item|
        expect(order_item.fulfilled).to eq(false)
        expect(order_item.item.inventory).to eq(5)
      end
    end

    it '.merchant_subtotal()' do
      expect(@order_2.merchant_subtotal(@megan.id)).to eq(40.5)
      expect(@order_2.merchant_subtotal(@brian.id)).to eq(100)
    end

    it '.merchant_quantity()' do
      expect(@order_2.merchant_quantity(@megan.id)).to eq(2)
      expect(@order_2.merchant_quantity(@brian.id)).to eq(2)
    end

    it '.is_packaged?' do
      @order_1.is_packaged?
      @order_2.is_packaged?

      @order_1.reload
      @order_2.reload

      expect(@order_1.status).to eq('packaged')
      expect(@order_2.status).to eq('pending')
    end

    it ".total_savings" do
      discount_1 = @megan.discounts.create(percent: 5, quantity: 3)
      discount_2 = @brian.discounts.create(percent: 5, quantity: 2)

      expect(@order_1.total_savings).to eq(5.05)
      expect(@order_2.total_savings).to eq(5)
    end
  end

  describe 'class methods' do
    before :each do
      @user = User.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan_1@example.com', password: 'securepassword')
      @order_1 = @user.orders.create!(status: 1)
      @order_2 = @user.orders.create!(status: 0)
      @order_3 = @user.orders.create!(status: 3)
      @order_4 = @user.orders.create!(status: 2)
    end

    it '.by_status' do
      expect(Order.by_status).to eq([@order_2, @order_1, @order_4, @order_3])
    end
  end
end
