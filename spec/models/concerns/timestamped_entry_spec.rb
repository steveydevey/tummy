require 'rails_helper'

RSpec.describe TimestampedEntry, type: :model do
  describe '.recent' do
    let!(:entry1) { FoodEntry.create!(description: 'Test 1', consumed_at: 2.days.ago) }
    let!(:entry2) { FoodEntry.create!(description: 'Test 2', consumed_at: 1.day.ago) }
    let!(:entry3) { FoodEntry.create!(description: 'Test 3', consumed_at: Time.current) }

    it 'orders by timestamp column descending' do
      # Test through FoodEntry which includes TimestampedEntry
      expect(FoodEntry.recent.pluck(:id)).to eq([entry3.id, entry2.id, entry1.id])
    end
  end

  describe '.on_date' do
    let(:target_date) { 1.day.ago.to_date }
    let!(:entry_on_date) { FoodEntry.create!(description: 'On date', consumed_at: target_date.beginning_of_day + 12.hours) }
    let!(:entry_before) { FoodEntry.create!(description: 'Before', consumed_at: target_date.beginning_of_day - 1.hour) }
    let!(:entry_after) { FoodEntry.create!(description: 'After', consumed_at: target_date.end_of_day + 1.hour) }

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

  describe '.timestamp_column' do
    it 'defaults to :occurred_at' do
      expect(BowelMovement.timestamp_column).to eq(:occurred_at)
    end

    it 'can be set to a different column' do
      original = FoodEntry.timestamp_column
      FoodEntry.timestamp_column = :consumed_at
      expect(FoodEntry.timestamp_column).to eq(:consumed_at)
      FoodEntry.timestamp_column = original
    end
  end
end

