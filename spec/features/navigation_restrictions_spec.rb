require 'rails_helper'

RSpec.describe 'Navigation Restrictions' do
  describe 'As a Visitor' do
    it 'I can not visit the user profile' do
      visit '/profile'
    end

    it 'I cannot visit the merchant dashboard' do
      visit '/merchant'
    end

    it 'I can not visit the admin dashboard' do
      visit '/admin'
    end

    after :each do
      expect(page.status_code).to eq(404)
    end
  end
end
