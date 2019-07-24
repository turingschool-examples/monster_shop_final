require 'rails_helper'

RSpec.describe 'Merchant Index Page' do
  describe 'As a visitor' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, enabled: true)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218, enabled: false)
    end

    it 'I see a list of all merchants' do
      visit '/merchants'

      within "#merchant-#{@megan.id}" do
        expect(page).to have_link(@megan.name)
        expect(page).to_not have_button('Disable')
      end

      within "#merchant-#{@brian.id}" do
        expect(page).to have_link(@brian.name)
        expect(page).to_not have_button('Enable')
      end
    end

    it 'I can click a link to get to a merchants show page' do
      visit '/merchants'

      click_link @megan.name

      expect(current_path).to eq("/merchants/#{@megan.id}")
    end
  end

  describe 'As an Admin' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, enabled: true)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218, enabled: false)
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: false, inventory: 3 )
      @admin = User.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: :admin)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
    end

    it 'I can disable a merchant' do
      visit '/merchants'

      within "#merchant-#{@megan.id}" do
        click_button('Disable')
      end

      expect(current_path).to eq(merchants_path)
      expect(page).to have_content("#{@megan.name} has been disabled")
      visit '/merchants'
      within "#merchant-#{@megan.id}" do
        expect(page).to have_button('Enable')
      end
    end

    it 'When I disable a merchant, their items become inactive' do
      page.driver.submit :patch, "/admin/merchants/#{@megan.id}", {}

      visit items_path

      expect(page).to_not have_css("#item-#{@giant.id}")
    end

    it 'I can enable a merchant' do
      visit '/merchants'

      within "#merchant-#{@brian.id}" do
        click_button('Enable')
      end

      expect(current_path).to eq(merchants_path)
      expect(page).to have_content("#{@brian.name} has been enabled")
      visit '/merchants'
      within "#merchant-#{@brian.id}" do
        expect(page).to have_button('Disable')
      end
    end

    it 'When I enable a merchant, their items become active' do
      page.driver.submit :patch, "/admin/merchants/#{@brian.id}", {}

      visit items_path

      expect(page).to have_css("#item-#{@hippo.id}")
    end
  end
end
