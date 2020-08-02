require 'rails_helper'

RSpec.describe Discount do
  describe 'Relationships' do
    it {should belong_to :merchant}
    it {should have_many :orders}
  end

  describe 'Validations' do
    it {should validate_presence_of :percentage}
  end
