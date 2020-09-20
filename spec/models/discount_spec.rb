require 'rails_helper'

RSpec.describe Discount do
  describe 'Relationships' do
    it {should belong_to :merchant}
    it {should have_many :discount_order_items}
    it {should have_many(:order_items).through(:discount_order_items)}
    it {should have_many(:items).through(:order_items)}
    it {should have_many(:orders).through(:order_items)}
  end

  describe 'Validations' do
    it {should validate_presence_of :threshold_quantity}
    it {should validate_presence_of :discount_percentage}
  end
end
