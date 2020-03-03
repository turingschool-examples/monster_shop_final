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

  def discount_count(merchant_id)
    Discount.where(merchant_id: "#{merchant_id}").where(:status => "active").distinct.count
  end

  def discounts_available?(merchant_id)
    0 < Discount.where(merchant_id: "#{merchant_id}").where(status: "active").distinct.count

  end

  def bulk_discounts(merchant_id)
    Discount.where(merchant_id: "#{merchant_id}").where(:status => "active").order(:percent_off).distinct

  end
  def discount_percentage(merchant_id, qty)
    discount = Discount.where(merchant_id: "#{merchant_id}").where(status: "active").order(percent_off: :desc).where("quantity_threshold = #{qty} or quantity_threshold < #{qty}").distinct.select(:percent_off).pluck(:percent_off).first
    if discount == nil
      return 0
    else
      discount
    end
  end

  def best_discount(merchant_id, qty)
    # binding.pry
    if discount_percentage(merchant_id, qty) == 0
      return nil
    else
      Discount.where("quantity_threshold = #{qty} or quantity_threshold < #{qty}").where(status: "active").where(merchant_id: "#{merchant_id}").order(percent_off: :desc).pluck(:id).first
    end
  end

  def price_after_discount(qty, item_id)
    item = Item.find(item_id)
    # binding.pry
    item.price - (item.price * (item.discount_percentage(item.merchant_id, qty)/100.to_f))
  end

end
