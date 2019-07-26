require 'rails_helper'

RSpec.describe UserAddress do
  describe 'relationships' do
    it {should belong_to :user}
    it {should belong_to :address}
  end
end 
