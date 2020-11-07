# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#merchants
megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
metroid_shop = Merchant.create(name: "Hope's Metroid Shop", address: '125 XR42 St.', city: 'Denver', state: 'CO', zip: 80210)

#bike_shop items
tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

#dog_shop items
pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

#metroid_shop items
missiles = metroid_shop.items.create(name: "Missiles", description: "Access to new areas!", price: 10, image: "https://i.ibb.co/HVNNc7V/item-missile.gif", inventory: 32)
power_bombs = metroid_shop.items.create(name: "Power Bombs", description: "No one is safe!", price: 200, image: "https://i.ibb.co/1rH5cp5/pbomb-n-02.gif", inventory: 21)
varia_suit = metroid_shop.items.create(name: "Varia Suit", description: "Get you through acid!", price: 500, image: "https://i.ibb.co/K6sQT2b/MP-VS.jpg", inventory: 32)
super_missiles = metroid_shop.items.create(name: "Super Missiles", description: "The boss puncher!", price: 100, image: "https://i.ibb.co/Kbgndr2/SM.jpg", inventory: 21)

#megan items
orge = megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
giant = megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )

#brian items
hippo = brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )

#users
  #default
user_1 = User.create!(name: "George",
                      street_address: "123 lane",
                      city: "Denver",
                      state: "CO",
                      zip: 80111,
                      email_address: "Georgeexample.com",
                      password: "superEasyPZ")
  #merchant
user_2 = User.create!(name: "Hope",
                      street_address: "456 Space st",
                      city: "Space",
                      state: "CO",
                      zip: 80111,
                      email_address: "Hopeexample.com",
                      password: "superEasyPZ",
                      role: 1,
                      merchant_id: metroid_shop.id)
  #admin
user_3 = User.create!(name: "Todd",
                      street_address: "789 Main st",
                      city: "Denver",
                      state: "CO",
                      zip: 80111,
                      email_address: "Toddexample.com",
                      password: "superEasyPZ",
                      role: 2)

#orders
order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: user_1.id)

order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2, status: "fulfilled")
order_1.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 3, status: "fulfilled")
order_1.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 3, status: "fulfilled")

order_2 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: user_1.id)

order_2.item_orders.create!(item: tire, price: tire.price, quantity: 2, status: "fulfilled")
order_2.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 3, status: "fulfilled")

order_2.item_orders.create!(item: dog_bone, price: dog_bone.price, quantity: 3)
