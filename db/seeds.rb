# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Merchant.destroy_all
Item.destroy_all
User.destroy_all
Order.destroy_all

megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)

ogre = megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 50 )
giant = megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 12, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 23 )
hippo = brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 5, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 15 )
lamp = brian.items.create!(name: 'Lamp', description: "I'm a Lamp!", price: 28, image: 'https://images.homedepot-static.com/productImages/967ebf56-03e4-48c3-90ea-43875341a53d/svn/rhodes-bronze-hampton-bay-table-lamps-hd09999tlbrzc-64_1000.jpg', active: true, inventory: 20 )

sam = User.create!(name: "Sam", address: "1331 17th St.", city: "Denver", state: "CO", zip: 80202, email: "sam@gmail.com", password: "test", role: 0)
lisa = User.create!(name: "Lisa", address: "13 Tree St.", city: "Miami", state: "FL", zip: 34102, email: "lisa@gmail.com", password: "1234", role: 0)
joe = User.create!(name: "Joe", address: "200 25th Ave", city: "Atlanta", state: "GA", zip: 54372, email: "joe@gmail.com", password: "5678", role: 0)
oswald = User.create!(name: "Oswald", address: "42 Woodward Way", city: "Boston", state: "MA", zip: 98471, email: "oswald@gmail.com", password: "9012", role: 0)

jack = User.create!(name: "Jack", address: "4 Green St.", city: "Austin", state: "TX", zip: 71352, email: "jack@gmail.com", password: "test", role: 1)
diane = User.create!(name: "Diane", address: "1 Blue St.", city: "Denver", state: "CO", zip: 80202, email: "diane@gmail.com", password: "test", role: 2, merchant_id: megan.id)
woody = User.create!(name: "Woody", address: "1 Blue St.", city: "Denver", state: "CO", zip: 80202, email: "woody@gmail.com", password: "test", role: 2, merchant_id: brian.id)

order_1 = Order.create!(user: sam, status: "pending")
order_2 = Order.create!(user: lisa, status: "pending")
order_3 = Order.create!(user: joe, status: "pending")
order_4 = Order.create!(user: oswald, status: "pending")

order_item_1 = order_1.order_items.create!(item: ogre, price: ogre.price, quantity: 2)
order_item_2 = order_1.order_items.create!(item: hippo, price: hippo.price, quantity: 4)
order_item_3 = order_2.order_items.create!(item: giant, price: giant.price, quantity: 3)
order_item_4 = order_2.order_items.create!(item: lamp, price: lamp.price, quantity: 1)
order_item_5 = order_3.order_items.create!(item: ogre, price: ogre.price, quantity: 2)
order_item_6 = order_3.order_items.create!(item: hippo, price: hippo.price, quantity: 3)
order_item_7 = order_4.order_items.create!(item: giant, price: giant.price, quantity: 4)
order_item_8 = order_4.order_items.create!(item: lamp, price: lamp.price, quantity: 5)
