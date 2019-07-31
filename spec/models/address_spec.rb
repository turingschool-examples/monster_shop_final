require 'rails_helper'

RSpec.describe Address, type: :model do
  describe 'relationships' do
      it {should belong_to :user}
      it {should have_many :orders}
    end

  describe 'instance_methods' do
      it ".shipments_check" do
        @user = User.create!(name: 'Megan', email: 'megan_1@example.com', password: 'securepassword')
        @address1 = @user.addresses.create(streetname: "123 market", city: "Denver", state: "CO", zip: 80132)
        @order1 = @user.orders.create(address_id: @address1.id, status: "pending")

        expect(@address1.shipments_check).to eq(false)
      end

      it ".shipments_check" do
        @user = User.create!(name: 'Megan', email: 'megan_1@example.com', password: 'securepassword')
        @address2 = @user.addresses.create(streetname: "123 market", city: "Calhan", state: "CO", zip: 45132)
        @order1 = @user.orders.create(address_id: @address2.id, status: "pending")
        @order2 = @user.orders.create(address_id: @address2.id, status: "shipped")

        expect(@address2.shipments_check).to eq(true)
      end

      it ".orders" do
        @user = User.create!(name: 'Megan', email: 'megan_1@example.com', password: 'securepassword')
        @address2 = @user.addresses.create(streetname: "123 market", city: "Calhan", state: "CO", zip: 45132)
        @address1 = @user.addresses.create(streetname: "123 market", city: "Calhan", state: "CO", zip: 45132)
        @order1 = @user.orders.create(address_id: @address2.id, status: "pending")
        @order2 = @user.orders.create(address_id: @address2.id, status: "shipped")

        expect(@address2.orders?).to eq(false)
        expect(@address1.orders?).to eq(true)
      end

    end
  end
