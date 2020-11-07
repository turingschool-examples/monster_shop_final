require 'rails_helper'

describe Discount do
  describe 'relationships' do
    it {should belong_to(:item)}
    it {should belong_to(:merchant)}
  end
end
