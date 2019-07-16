require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    describe 'I see a nav bar where I can link to' do
      it 'the welcome page' do
        visit items_path

        within 'nav' do
          click_link 'Home'
        end

        expect(current_path).to eq(root_path)
      end

      it 'all items' do
        visit root_path

        within 'nav' do
          click_link 'Items'
        end

        expect(current_path).to eq(items_path)
      end

      it 'all merchants' do
        visit root_path

        within 'nav' do
          click_link 'Merchants'
        end

        expect(current_path).to eq(merchants_path)
      end

      it 'my cart' do
        visit root_path

        within 'nav' do
          click_link 'Cart: 0'
        end

        expect(current_path).to eq(cart_path)
      end

      it 'the login page' do
        visit root_path

        within 'nav' do
          click_link 'Log In'
        end

        expect(current_path).to eq(login_path)
      end

      it 'the registraton page' do
        visit root_path

        within 'nav' do
          click_link 'Register'
        end

        expect(current_path).to eq(registration_path)
      end
    end
  end
end
