class Discount <ApplicationRecord
  validates_presence_of :name, :percent, :threshold
  belongs_to :merchant
end
