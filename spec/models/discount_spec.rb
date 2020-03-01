require 'rails_helper'

describe Discount do
  describe 'Relationships' do
    it {should belong_to :merchant}
    it {should have_many :item_discounts}
    it {should have_many(:items).through(:item_discounts)}
  end
end