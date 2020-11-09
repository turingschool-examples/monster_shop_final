class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def full_address
    "#{self.address}, #{self.city}, #{self.state}, #{self.zip}"
  end

  def find_item(item_id)
    item = Item.find(item_id)
  end
end
