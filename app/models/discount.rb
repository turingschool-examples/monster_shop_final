class Discount < ApplicationRecord
belongs_to :merchant

  def self.discount_rate(amount)
    where(limit: amount).order(limit: :desc).first
  end
end
