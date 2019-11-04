require 'rails_helper'

RSpec.describe 'Navigation Restrictions' do
  describe 'As a Visitor' do
    xit 'I can not visit the user profile' do
      visit '/profile'
    end

    xit 'I cannot visit the merchant dashboard' do
      visit '/merchant'
    end

    xit 'I cannot visit the merchant order show' do
      visit '/merchant/orders/3'
    end

    xit 'I cannot visit the merchant items index' do
      visit '/merchant/items'
    end

    xit 'I can not patch to /merchant/items/:id' do
      page.driver.submit :patch, '/merchant/items/3', {}
    end

    xit 'I can not delete to /merchant/items/:id' do
      page.driver.submit :delete, "/merchant/items/3", {}
    end

    xit 'I can not visit new merchant item' do
      visit '/merchant/items/new'
    end

    xit 'I can not post to /merchant/items' do
      page.driver.submit :post, '/merchant/items', {}
    end

    xit 'I can not visit edit merchant item' do
      visit '/merchant/items/3/edit'
    end

    xit 'I can not put to /merchant/items' do
      page.driver.submit :put, '/merchant/items/3', {}
    end

    xit 'I can not visit the admin dashboard' do
      visit '/admin'
    end

    xit 'I can not visit the admin merchant show page' do
      visit '/admin/merchants/3'
    end

    xit 'I can not visit the admin users page' do
      visit '/admin/users'
    end

    xit 'I can not patch to /merchant/:id' do
      page.driver.submit :patch, 'admin/merchants/3', {}
    end

    after :each do
      expect(page.status_code).to eq(404)
    end
  end

  describe 'As a Default User' do
    before :each do
      @user = User.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    xit 'I cannot visit the merchant dashboard' do
      visit '/merchant'
    end

    xit 'I cannot visit the merchant order show' do
      visit '/merchant/orders/3'
    end

    xit 'I cannot visit the merchant items index' do
      visit '/merchant/items'
    end

    xit 'I can not patch to /merchant/items/:id' do
      page.driver.submit :patch, '/merchant/items/3', {}
    end

    xit 'I can not delete to /merchant/items/:id' do
      page.driver.submit :delete, "/merchant/items/3", {}
    end

    xit 'I can not visit new merchant item' do
      visit '/merchant/items/new'
    end

    xit 'I can not post to /merchant/items' do
      page.driver.submit :post, '/merchant/items', {}
    end


    xit 'I can not visit edit merchant item' do
      visit '/merchant/items/3/edit'
    end

    xit 'I can not put to /merchant/items' do
      page.driver.submit :put, '/merchant/items/3', {}
    end

    xit 'I can not visit the admin dashboard' do
      visit '/admin'
    end

    xit 'I can not visit the admin merchant show page' do
      visit '/admin/merchants/3'
    end


    xit 'I can not visit the admin users page' do
      visit '/admin/users'
    end

    xit 'I can not patch to /merchant/:id' do
      page.driver.submit :patch, 'admin/merchants/3', {}
    end

    after :each do
      expect(page.status_code).to eq(404)
    end
  end

  describe 'As a Merchant User (Employee)' do
    before :each do
      @merchant = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    xit 'I can not visit the admin dashboard' do
      visit '/admin'
    end

    xit 'I can not visit the admin merchant show page' do
      visit '/admin/merchants/3'
    end


    xit 'I can not visit the admin users page' do
      visit '/admin/users'
    end

    xit 'I can not patch to /merchant/:id' do
      page.driver.submit :patch, 'admin/merchants/3', {}
    end

    after :each do
      expect(page.status_code).to eq(404)
    end
  end

  describe 'As an Admin' do
    before :each do
      @admin = User.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: :admin)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
    end

    xit 'I can not visit the user profile' do
      visit '/profile'
    end

    xit 'I cannot visit the merchant dashboard' do
      visit '/merchant'
    end

    xit 'I cannot visit the merchant order show' do
      visit '/merchant/orders/3'
    end

    xit 'I cannot visit the merchant items index' do
      visit '/merchant/items'
    end

    xit 'I can not patch to /merchant/items/:id' do
      page.driver.submit :patch, '/merchant/items/3', {}
    end

    xit 'I can not delete to /merchant/items/:id' do
      page.driver.submit :delete, "/merchant/items/3", {}
    end

    xit 'I can not visit new merchant item' do
      visit '/merchant/items/new'
    end

    xit 'I can not post to /merchant/items' do
      page.driver.submit :post, '/merchant/items', {}
    end

    xit 'I can not visit edit merchant item' do
      visit '/merchant/items/3/edit'
    end

    xit 'I can not put to /merchant/items' do
      page.driver.submit :put, '/merchant/items/3', {}
    end

    xit 'I cannot visit a cart' do
      visit '/cart'
    end

    after :each do
      expect(page.status_code).to eq(404)
    end
  end
end
