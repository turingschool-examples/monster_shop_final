require 'rails_helper'

RSpec.describe Review do
  describe 'Relationships' do
    it {should belong_to :item}
  end
end
