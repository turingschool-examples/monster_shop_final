class Discount <ApplicationRecord
  validates_presence_of :name
  validates :percent,presence:true, numericality: {only_integer: true, less_than: 100}
  validates :threshold,presence:true, numericality: {only_integer: true}
  belongs_to :merchant
end
