require 'rails_helper'

RSpec.describe 'Destroy Existing Merchant' do
  describe 'As a visitor' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @brian.items.create!(name: 'Giant', description: "I'm a Giant!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @user = User.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @order = @user.orders.create!
      @order.order_items.create(item: @ogre, quantity: 3, price: @ogre.price)
    end

    it 'I can click button to destroy merchant from database' do
      visit "/merchants/#{@brian.id}"

      click_button 'Delete'

      expect(current_path).to eq('/merchants')
      expect(page).to_not have_content(@brian.name)
    end

    it 'When a merchant is destroyed, their items are also destroyed' do
      page.driver.submit :delete, "/merchants/#{@brian.id}", {}

      visit items_path

      expect(page).to_not have_content(@giant.name)
    end

    describe 'If a merchant has items that have been ordered' do
      it 'I do not see a button to delete the merchant' do
        visit "/merchants/#{@megan.id}"

        expect(page).to_not have_button('Delete')
      end

      it 'I can not delete a merchant' do
        page.driver.submit :delete, "/merchants/#{@megan.id}", {}

        expect(page).to have_content(@megan.name)
        expect(page).to have_content("#{@megan.name} can not be deleted - they have orders!")
      end
    end
  end
end
