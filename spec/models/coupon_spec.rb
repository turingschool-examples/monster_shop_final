# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Coupon do
  describe 'Relationships' do
    it { should belong_to :merchant }
    it { should have_many :coupon_users }
  end

  describe 'Validations' do
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name}

    it { should validate_presence_of :discount }
    it { should validate_numericality_of :discount}
  end

  describe 'Methods' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80_218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3)
      @coupon = @megan.coupons.create!(name: 'Discount 1', discount: 10)
      @user = User.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80_218, email: 'megan_1@example.com', password: 'securepassword')
      @order = @user.orders.create!(status: 'pending')
      @order_item = @order.order_items.create!(item: @ogre, price: @ogre.price, quantity: 5, fulfilled: true)
      CouponUser.create(coupon_id: @coupon.id, user_id: @user.id, order_id: @order.id)
    end

    it 'used?' do
      expect(@coupon.used?.empty?).to eq(false)
    end
  end
end
