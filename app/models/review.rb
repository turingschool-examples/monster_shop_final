class Review < ApplicationRecord
  belongs_to :item

  validates_inclusion_of :rating, in: 1..5, message: "Rating must be 1 - 5"
  validates_presence_of :title, :description
end
