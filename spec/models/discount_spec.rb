require 'rails_helper'

RSpec.describe Discount do
  describe 'Relationships' do
    it { should belong_to :item }
  end
end
