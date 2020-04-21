class Discount <ApplicationRecord
  validates_presence_of :name, :percent
  belongs_to :merchant
end
