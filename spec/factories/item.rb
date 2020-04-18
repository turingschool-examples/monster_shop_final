FactoryBot.define do
  factory :item, class: Item do
    name        { Faker::Commerce.product_name}
    description { Faker::ChuckNorris.fact }
    price       { Faker::Commerce.price}
    image       { Faker::Avatar.image }
    inventory   { Faker::Number.between(from: 1, to: 500)}
  end
end
