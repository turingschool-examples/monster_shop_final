# frozen_string_literal: true

# merchants
bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)

# regular user
User.create(name: 'User', address: '123 Main', city: 'Denver', state: 'CO', zip: 80_233, email: 'user_1@user.com', password: 'secure', role: 0)

# merchant admin
bike_shop.users.create(name: 'Bike Admin', address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203, email: 'bike_admin@user.com', password: 'secure', role: 1)

# site admin
User.create(name: 'Site Admin', address: '123 First', city: 'Denver', state: 'CO', zip: 80_233, email: 'site_admin@user.com', password: 'secure', role: 2)
