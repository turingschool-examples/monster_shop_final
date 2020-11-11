class Discount < ApplicationRecord
  belongs_to :merchant
  validates_presence_of :percent_off,
                        :item_requirement

  validates_numericality_of :percent_off, greater_than: 0, less_than: 1
  validates_numericality_of :item_requirement, greater_than: 0

  def percentage_display
    (percent_off * 100).to_i
  end
  
end
