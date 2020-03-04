require 'rails_helper'

RSpec.describe Discount do
  describe 'Relationships' do
    it {should belong_to :merchant}
    it {should have_many(:items).through (:merchant)}
    it {should have_many(:order_items).through (:items)}
    it {should have_many(:orders).through (:order_items)}
  end

  describe 'Validations' do
    it {should validate_presence_of :percent_off}
    it {should validate_presence_of :quantity_threshold}
    it {should validate_presence_of :status}
  end

  describe 'Instance Methods' do
    before(:each) do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @ogre = @merchant_1.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 80 )
      @giant = @merchant_1.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 80 )
      @discount1 = @merchant_1.discounts.create!(percent_off: 5, quantity_threshold: 20, status: "active")
      @discount2 = @merchant_1.discounts.create!(percent_off: 10, quantity_threshold: 40, status: "active")
      @discount3 = @merchant_1.discounts.create!(percent_off: 15, quantity_threshold: 50, status: "active")
      @discount4 = @merchant_1.discounts.create!(percent_off: 20, quantity_threshold: 30, status: "active")
      @order_1 = @m_user.orders.create!(status: "pending")
      @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 30, fulfilled: false, discount_id: @discount4.id)
      @order_1.order_items.create!(item: @giant, price: @giant.price, quantity: 20, fulfilled: true, discount_id: @discount1.id)
    end

    it "can see if a discount has been used" do
      expect(@discount1.has_not_been_used(@discount1.id)).to eq(false)
      expect(@discount2.has_not_been_used(@discount2.id)).to eq(true)
      expect(@discount3.has_not_been_used(@discount3.id)).to eq(true)
      expect(@discount4.has_not_been_used(@discount4.id)).to eq(false)
    end
  end
end
