class Address < ApplicationRecord
belongs_to :user
has_many :orders

validates_presence_of :streetname,
                      :city,
                      :state,
                      :zip

enum nickname: ["home", "work", "alternate"]

  def shipments_check
    orders.where(status: "shipped").any?
  end

  def orders?
    orders.empty?
  end

end
