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

    describe '.recent' do
      it 'orders by consumed_at descending' do
        expect(FoodEntry.recent).to eq([entry3, entry2, entry1])
      end
    end

    describe '.on_date' do
      let(:target_date) { 1.day.ago.to_date }
      let!(:entry_on_date) { create(:food_entry, consumed_at: target_date.beginning_of_day + 12.hours) }
      let!(:entry_before) { create(:food_entry, consumed_at: target_date.beginning_of_day - 1.hour) }
      let!(:entry_after) { create(:food_entry, consumed_at: target_date.end_of_day + 1.hour) }

      it 'returns entries on the specified date' do
        expect(FoodEntry.on_date(target_date)).to include(entry_on_date)
      end

      it 'excludes entries before the date' do
        expect(FoodEntry.on_date(target_date)).not_to include(entry_before)
      end

      it 'excludes entries after the date' do
        expect(FoodEntry.on_date(target_date)).not_to include(entry_after)
      end
    end
  end
end
