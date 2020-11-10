require 'rails_helper'

RSpec.describe Discount do
  describe 'Relationships' do
    it {should belong_to :item}
  end

  describe 'Validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :percentage}
    it {should validate_presence_of :minimum_quantity}
  end
end
