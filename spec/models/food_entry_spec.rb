require 'rails_helper'

RSpec.describe FoodEntry, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:consumed_at) }
  end

  describe 'scopes' do
    let!(:entry1) { create(:food_entry, consumed_at: 2.days.ago) }
    let!(:entry2) { create(:food_entry, consumed_at: 1.day.ago) }
    let!(:entry3) { create(:food_entry, consumed_at: Time.current) }

    it 'orders by consumed_at descending' do
      expect(FoodEntry.recent).to eq([entry3, entry2, entry1])
    end
  end
end
