require 'rails_helper'

RSpec.describe Address do
  describe 'Relationships' do
    it {should belong_to :user}
    it {should have_many :orders}
  end

  describe 'Validations' do
    it {should validate_presence_of :address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zip}
    it {should validate_presence_of :nickname}
  end
end
