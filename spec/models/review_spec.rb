require 'rails_helper'

RSpec.describe Review do
  describe 'Relationships' do
    it {should belong_to :item}
  end

  describe 'Validations' do
    it {should validate_inclusion_of(:rating)
          .in_range(1..5)
          .with_message("Rating must be 1 - 5")}
    it {should validate_presence_of :title}
    it {should validate_presence_of :description}
  end
end
