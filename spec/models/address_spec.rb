require 'rails_helper'

RSpec.describe Address, type: :model do
  describe 'relationships' do
      it {should belong_to :user}
      it {should have_many :orders}
    end
  end
