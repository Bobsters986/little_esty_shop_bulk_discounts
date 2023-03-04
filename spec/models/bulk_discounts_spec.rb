require 'rails_helper'

describe BulkDiscount do
  describe "relationships" do
    it { should belong_to :merchant }
    it { should validate_presence_of :percentage_discount}
    it { should validate_presence_of :quantity_threshold}
    it { should validate_numericality_of :percentage_discount}
    it { should validate_numericality_of :quantity_threshold}
  end
end