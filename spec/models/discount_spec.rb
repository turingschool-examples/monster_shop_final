require 'rails_helper'

Rspec.describe Discount do
  describe 'Relationships' do
    it { should belong_to :item }
  end
end
