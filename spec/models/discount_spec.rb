require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe 'Validations' do
    it {should validate_presence_of :title}
    it {should validate_presence_of :percent_off}
    it {should validate_presence_of :information}
    it {should validate_presence_of :lowest_amount}
    it {should validate_presence_of :highest_amount}
  end

  describe 'Relationships' do
    it {should belong_to :merchant}
  end
end
