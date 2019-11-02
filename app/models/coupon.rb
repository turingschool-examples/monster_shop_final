# frozen_string_literal: true

class Coupon < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :name,
                        :discount

  validates_uniqueness_of :name
end
