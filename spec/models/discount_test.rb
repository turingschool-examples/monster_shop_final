require 'test_helper'

class DiscountTest < ActiveSupport::TestCase
  describe 'Relationships' do
    it {should belong_to :merchant}
  end 
  describe 'Validations' do
    it {should validate_presence_of :percent_off}
    it {should validate_presence_of :item_requirement}
    it {should validate_presence_of :active}
  end 
end 
