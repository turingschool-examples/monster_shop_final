# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admin = User.create(name: 'Mike', address: '129 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'mike@example.com', password: 'securepassword', role: :admin)

megan = Merchant.create!(name: 'Megans Marvelous Creatures', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
brian = Merchant.create!(name: 'Brians Boss Beasts', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)

m_user = megan.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
m2_user = brian.create(name: 'Brian', address: '128 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'brian@example.com', password: 'securepassword')

user = User.create(name: 'Tin', address: '128 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'Tin@example.com', password: 'securepassword')
user = User.create(name: 'Charles', address: '128 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'charles@example.com', password: 'securepassword')

megan.items.create(name: 'Ogre', description: "I'm an Ogre!", price: 50, image: 'https://www.cjnews.com/wp-content/uploads/2019/05/shrek-f.jpg', active: true, inventory: 500 )
megan.items.create(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://media-waterdeep.cursecdn.com/avatars/thumbnails/0/331/222/315/636252776196140305.jpeg', active: true, inventory: 300 )
megan.items.create(name: 'Unicorn', description: "I'm an Unicorn!", price: 50, image: 'https://i.ebayimg.com/images/g/Pv4AAOSwTxhcOpJq/s-l640.jpg', active: true, inventory: 500 )
megan.items.create(name: 'Griffin', description: "I'm a Griffin!", price: 50, image: 'http://unisci24.com/data_images/wlls/22/245170-griffin.jpg', active: true, inventory: 300 )
brian.items.create(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://static.parade.com/wp-content/uploads/2018/02/Hippo-Day-2018.jpg', active: true, inventory: 300 )
brian.items.create(name: 'Rhino', description: "I'm a Rhino!", price: 50, image: 'https://www.dw.com/image/51954977_303.jpg', active: true, inventory: 300 )
brian.items.create(name: 'Elephant', description: "I'm an Elephant!", price: 50, image: 'https://miro.medium.com/max/11906/1*3W3LluXXjsejCE7ferQ0bw.jpeg', active: true, inventory: 300 )
brian.items.create(name: 'Dolphin', description: "I'm a Dolphin!", price: 50, image: 'https://www.dolphinproject.com/wp-content/uploads/2019/07/Maya.jpg', active: true, inventory: 300 )

discount1 = megan.discounts.create(percent_off: 3, quantity_threshold: 2, status: "active")
discount2 = megan.discounts.create(percent_off: 4, quantity_threshold: 4, status: "active")
discount3 = megan.discounts.create(percent_off: 5, quantity_threshold: 5, status: "inactive")
discount4 = megan.discounts.create(percent_off: 5, quantity_threshold: 20, status: "active")
discount5 = megan.discounts.create(percent_off: 10, quantity_threshold: 30, status: "active")

discount6 = brian.discounts.create(percent_off: 3, quantity_threshold: 2, status: "active")
discount7 = brian.discounts.create(percent_off: 4, quantity_threshold: 5, status: "active")
discount8 = brian.discounts.create(percent_off: 5, quantity_threshold: 20, status: "active")
discount9 = brian.discounts.create(percent_off: 15, quantity_threshold: 20, status: "inactive")
discount10 = brian.discounts.create(percent_off: 10, quantity_threshold: 30, status: "inactive")
