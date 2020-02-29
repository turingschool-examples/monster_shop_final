class Discount < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :percent_off,
                        :quantity_threshold,
                        :status


  enum role: ['active', 'inactive']

end
