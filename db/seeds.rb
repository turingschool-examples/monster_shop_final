# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'

megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)

10.times do
    description = Faker::Movies::HarryPotter.quote
    name = Faker::Games::Pokemon.unique.name
    price = Faker::Number.number(digits: 3)
    image = Faker::Fillmurray.image
    inventory = Faker::Number.number(digits: 3)

    megan.items.create!(name: name, description: description, price: price, image: image, active: true, inventory: inventory)
end

10.times do
    name = Faker::Games::Pokemon.unique.name
    description = Faker::Movies::HarryPotter.quote
    price = Faker::Number.number(digits: 3)
    image = Faker::Fillmurray.image
    inventory = Faker::Number.number(digits: 3)

    brian.items.create!(name: name, description: description, price: price, image: image, active: true, inventory: inventory)
end