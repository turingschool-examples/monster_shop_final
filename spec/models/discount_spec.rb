RSpec.describe Discount do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :item_minimum }
    it { should validate_presence_of :percent }
    it { should validate_presence_of :merchant_id }
  end
  
  describe 'relationships' do
    it { should belong_to :merchant }
  end
end
