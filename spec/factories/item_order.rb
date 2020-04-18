FactoryBot.define do
  factory :item_order, class: ItemOrder do
    price        { Faker::Commerce.price }
    quantity     { Faker::Number.between(from: 1, to: 200) }
    association  :item, factory: :item
    association  :order, factory: :order
  end
end
