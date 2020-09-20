# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Merchant.destroy_all
User.destroy_all
Item.destroy_all
Order.destroy_all
# ItemOrder.destroy_all

# Merchants:
megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
dunder_mifflin = Merchant.create!(name: 'Dunder Mifflin Paper Company, Inc.', address: '1725 Slough Avenue', city: 'Scranton', state: 'PA', zip: 18505)

# Users:
elah = User.create!(name: "Elah Pillado", address: "123 Chase Rd", city: "Marietta", state: "GA", zip: 30008, email: "elah@email.com", password: "password", role: 0)
aurora = megan.users.create!(name: "Aurora Ziobrowski", address: "999 Main St", city: "Denver", state: "CO", zip: 80218, email: "aurora@email.com", password: "unicorn", role: 1)
kat = megan.users.create!(name: "Kathleen Scriver", address: "1010 Main St", city: "Denver", state: "CO", zip: 80218, email: "kat@email.com", password: "unicorn", role: 1)
dwight = dunder_mifflin.users.create!(name: "Dwight Kurt Schrute III", address: "123 Beet Farm", city: "Scranton", state: "PA", zip: 18510, email: "d-money@email.com", password: "angela", role: 1)
jim = dunder_mifflin.users.create!(name: "James Duncan Halpert", address: "13831 Calvert Street", city: "Scranton", state: "PA", zip: 18510, email: "bigtuna@email.com", password: "pam", role: 1)
michaelscott = User.create(name: "Michael Scott", address: "126 Kellum Court", city: "Scranton", state: "PA", zip: 18510, email: "michaelscarn@email.com", password: "holly", password_confirmation: "holly", role: 2)

# Items:
megan.items.create!(name: 'Orange', description: "Made with sweet oranges and lemon.", price: 10, image: 'https://www.culinaryhill.com/wp-content/uploads/2019/06/culinary-hill-orange-marmalade-square-1.jpg', active: true, inventory: 5 )
megan.items.create!(name: 'Strawberry', description: "Naturally paleo and vegan.", price: 7, image: 'https://www.texanerin.com/content/uploads/2012/06/how-to-make-strawberry-jam-2.jpg', active: true, inventory: 10 )
brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
dunder_mifflin.items.create!(name: 'Paper', description: "Premium copy papter", price: 20, image: 'https://dundermifflinpaper.com/wp-content/uploads/2013/06/20190824_185517.jpg', active: true, inventory: 50 )
dunder_mifflin.items.create!(name: 'Sweatshirt', description: "Soft and perfect for winter.", price: 20, image: 'https://teeshope.com/wp-content/uploads/2019/11/dunder-mifflin-inc-sweatshirt.jpg', active: true, inventory: 25 )
dunder_mifflin.items.create!(name: 'Pen', description: "Ball point black ink.", price: 3, image: 'https://dundermifflinpaper.com/wp-content/uploads/2019/09/IMG-0738.jpg', active: true, inventory: 50 )
