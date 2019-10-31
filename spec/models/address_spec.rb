require 'rails_helper'

RSpec.describe Address do
  describe 'Relationships' do
    it {should belong_to :user}
    it {should have_many(:orders).through(:users)}
  end

  describe 'Validations' do
    it {should validate_presence_of :address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zip}
    it {should validate_presence_of :user_id}
    it {should validate_presence_of :nickname}
    it {should validate_uniqueness_of :nickname}
  end
end

# belongs_to :user
# has_many :orders, through: :users
# validates_uniqueness_of :nickname, scope: :user_id, confirmation: { case_sensitive: false }
