class Item < ApplicationRecord
  belongs_to :merchant
  has_many :order_items
  has_many :orders, through: :order_items
  has_many :reviews, dependent: :destroy
  has_many :discounts, through: :merchant

  validates_presence_of :name,
                        :description,
                        :image,
                        :price,
                        :inventory

  def self.active_items
    where(active: true)
  end

  def self.by_popularity(limit = nil, order = "DESC")
    left_joins(:order_items)
    .select('items.id, items.name, COALESCE(sum(order_items.quantity), 0) AS total_sold')
    .group(:id)
    .order("total_sold #{order}")
    .limit(limit)
  end

  def sorted_reviews(limit = nil, order = :asc)
    reviews.order(rating: order).limit(limit)
  end

  def average_rating
    reviews.average(:rating)
  end

  def discount(number_of_items)
    valid_discount = discounts.where("item_requirement <= #{number_of_items}").order(percent_off: :desc).limit(1)
    if valid_discount.empty? 
      1
    else 
      1 - valid_discount.first.percent_off
    end
  end

  def discounted_price(number_of_items)
    price * discount(number_of_items)
  end
end
