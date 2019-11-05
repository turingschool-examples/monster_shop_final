# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  describe 'Relationships' do
    it { should belong_to(:merchant).optional }
    it { should have_many :orders }
  end

  describe 'Validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
  end

  describe 'methods' do
    before :each do
      @merchant = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80_218)
      @ogre = @merchant.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5)
      @coupon = @merchant.coupons.create!(name: 'Discount 1', discount: 10)
      @user = User.create!(name: 'Christopher', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80_218, email: 'ck@email.com', password: 'password')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      @order = @user.orders.create!(status: 'pending')
      @order_item_1 = @order.order_items.create!(item: @ogre, price: @ogre.price, quantity: 5, fulfilled: true)
    end

    it 'find_coupon()' do
      expect(@user.find_coupon(@coupon).empty?).to eq(true)
    end
  end
end
