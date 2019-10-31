require 'rails_helper'

RSpec.describe Review do
  describe 'Relationships' do
    xit {should belong_to :item}
  end

  describe 'Validations' do
    xit {should validate_inclusion_of(:rating)
          .in_range(1..5)
          .with_message("Rating must be 1 - 5")}
    xit {should validate_presence_of :title}
    xit {should validate_presence_of :description}
  end
end
