class Discount < ApplicationRecord

  belongs_to :merchant

  validates_presence_of :percentage, :item_count

end
