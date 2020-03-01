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
end
