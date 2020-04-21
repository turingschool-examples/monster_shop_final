require 'rails_helper'

RSpec.describe Discount do

  describe 'relationships' do
    it {should belong_to :merchants}
  end

  describe 'validations' do
    it {should validate_presence_of :percentage}
    it {should validate_presence_of :bulk}
  end

end
