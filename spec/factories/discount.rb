FactoryBot.define do
  factory :discount, class: Discount do
    name        { Faker::Games::Pokemon.name}
    percent_off { Faker::Number.within(range: 1..100) }
    min_quantity{ Faker::Number.within(range: 1..10) }
    association :merchant, factory: :merchant
  end
end
