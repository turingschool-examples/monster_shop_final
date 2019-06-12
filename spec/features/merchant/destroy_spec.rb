require 'rails_helper'

RSpec.describe 'Destroy Existing Merchant' do
  describe 'As a visitor' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
    end

    it 'I can click button to destroy merchant from database' do
      visit "/merchants/#{@brian.id}"

      click_button 'Delete'

      expect(current_path).to eq('/merchants')
      expect(page).to_not have_content(@brian.name)
    end
  end
end
