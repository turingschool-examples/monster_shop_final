require 'rails_helper'

RSpec.describe OrderDiscount do
  describe 'relationships' do
    it {should belong_to :order}
    it {should belong_to :discount}
  end

  describe 'instance methods' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @discount_1 = @merchant_1.discounts.create!(name: "20% Off")
      @discount_2 = @merchant_1.discounts.create!(name: "50% Off")
      @discount_3 = @merchant_1.discounts.create!(name: "75% Off")
      @user = User.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @order_1 = @user.orders.create!
      @order_2 = @user.orders.create!
      @order_discount_1 = @order_1.order_discounts.create!(discount: @discount_1)
      @order_discount_2 = @order_2.order_discounts.create!(discount: @discount_2)
    end
  end
end
