require 'rails_helper'

describe Discount do
  describe 'Relationships' do
    it {should belong_to :merchant}
  end
end