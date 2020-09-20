require 'rails_helper'

RSpec.describe Discount do
  describe 'Relationships' do
    it {should belong_to :merchant}
    it {should have_many :order_discounts}
    it {should have_many(:orders).through(:order_discounts)}
  end

  describe 'Validations' do
    it {should validate_presence_of :percent}
    it {should validate_presence_of :min_items}
  end

  describe 'Class Methods' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Morgans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Ashley', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'ashley@example.com', password: 'securepassword')
      @discount_1 = @merchant_1.discounts.create!(percent: 20, min_items: 5, active: true)
      @discount_2 = @merchant_1.discounts.create!(percent: 50, min_items: 10)
      @discount_3 = @merchant_1.discounts.create!(percent: 75, min_items: 20, active: true)
      @user = User.create!(name: 'Gram', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'gram@example.com', password: 'securepassword')
      @order_1 = @user.orders.create!
      @order_2 = @user.orders.create!
      @order_3 = @user.orders.create!
      @order_1.order_discounts.create!(discount: @discount_1)
      @order_2.order_discounts.create!(discount: @discount_2)
      @order_3.order_discounts.create!(discount: @discount_3)
    end

    it '.active_discounts' do
      expect(Discount.active_discounts).to eq([@discount_1, @discount_3])
    end


  end
end
