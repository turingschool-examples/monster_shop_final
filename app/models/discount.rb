class Discount < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :percent, :quantity_required
end
