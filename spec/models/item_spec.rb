require 'rails_helper'

RSpec.describe Item do
  describe 'Relationships' do
    it {should belong_to :merchant}
    it {should have_many :order_items}
    it {should have_many(:orders).through(:order_items)}
    it {should have_many :reviews}
  end
end
