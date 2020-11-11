class Discount < ApplicationRecord
  belongs_to :merchant
  has_many :items, through: :merchant
  validates_presence_of :description
  validates_presence_of :quantity
  validates_presence_of :percent
  validates :enable, inclusion: [true, false]

  def enabled_status
    if enable?
      message = 'Enabled'
    else
      message = 'Disabled'
    end
  end
end
