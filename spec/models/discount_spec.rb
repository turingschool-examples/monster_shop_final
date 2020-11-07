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
end
