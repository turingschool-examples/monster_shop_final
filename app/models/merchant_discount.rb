class MerchantDiscount < ApplicationRecord
  belongs_to :merchant
  belongs_to :discount 
end
