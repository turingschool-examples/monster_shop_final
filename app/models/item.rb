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

  def discount_count
    Discount.where(merchant_id: "#{self.merchant_id}").where(:status => "active").distinct.count
  end

  def discounts_available?
    0 < Discount.where(merchant_id: "#{self.merchant_id}").where(status: "active").distinct.count
  end

  def bulk_discounts
    Discount.where(merchant_id: "#{self.merchant_id}").where(:status => "active").order(:percent_off).distinct
  end

  def discount_percentage(qty)
    discount = Discount.where(merchant_id: "#{self.merchant_id}").where(status: "active").order(percent_off: :desc).where("quantity_threshold = #{qty} or quantity_threshold < #{qty}").distinct.select(:percent_off).pluck(:percent_off).first.to_f
  end

  def best_discount(qty)
    if discount_percentage(qty) == 0
      return nil
    else
      Discount.where("quantity_threshold = #{qty} or quantity_threshold < #{qty}").where(status: "active").where(merchant_id: "#{self.merchant_id}").order(percent_off: :desc).pluck(:id).first
    end
  end

  def price_after_discount(qty)
    self.price - (self.price * (self.discount_percentage(qty)/100))
  end
end
