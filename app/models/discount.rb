class Discount < ApplicationRecord
belongs_to :merchant

validates_presence_of :name,
                      :percentage,
                      :limit


  def self.discount_rate(amount)
    where("discounts.limit <= ?", amount).order(limit: :desc).first
  end
end
