FactoryBot.define do
  factory :order_item, class: OrderItem do
    price        { Faker::Commerce.price }
    quantity     { Faker::Number.between(from: 1, to: 200) }
    association  :item, factory: :item
    association  :order, factory: :order
  end
end
