require 'rails_helper'

RSpec.describe BowelMovement, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:occurred_at) }
    it { should validate_inclusion_of(:severity).in_array([1, 2, 3, 4, 5]).allow_nil }
  end

  describe 'scopes' do
    let!(:movement1) { create(:bowel_movement, occurred_at: 2.days.ago) }
    let!(:movement2) { create(:bowel_movement, occurred_at: 1.day.ago) }
    let!(:movement3) { create(:bowel_movement, occurred_at: Time.current) }

    describe '.recent' do
      it 'orders by occurred_at descending' do
        expect(BowelMovement.recent).to eq([movement3, movement2, movement1])
      end
    end

    describe '.on_date' do
      let(:target_date) { 1.day.ago.to_date }
      let!(:movement_on_date) { create(:bowel_movement, occurred_at: target_date.beginning_of_day + 12.hours) }
      let!(:movement_before) { create(:bowel_movement, occurred_at: target_date.beginning_of_day - 1.hour) }
      let!(:movement_after) { create(:bowel_movement, occurred_at: target_date.end_of_day + 1.hour) }

      it 'returns movements on the specified date' do
        expect(BowelMovement.on_date(target_date)).to include(movement_on_date)
      end

      it 'excludes movements before the date' do
        expect(BowelMovement.on_date(target_date)).not_to include(movement_before)
      end

      it 'excludes movements after the date' do
        expect(BowelMovement.on_date(target_date)).not_to include(movement_after)
      end
    end
  end

  describe '#severity_term' do
    it 'returns the correct term for severity 1' do
      movement = build(:bowel_movement, severity: 1)
      expect(movement.severity_term).to eq('Liquid')
    end

    it 'returns the correct term for severity 2' do
      movement = build(:bowel_movement, severity: 2)
      expect(movement.severity_term).to eq('Mush')
    end

    it 'returns the correct term for severity 3' do
      movement = build(:bowel_movement, severity: 3)
      expect(movement.severity_term).to eq('Firm')
    end

    it 'returns the correct term for severity 4' do
      movement = build(:bowel_movement, severity: 4)
      expect(movement.severity_term).to eq('Logs')
    end

    it 'returns the correct term for severity 5' do
      movement = build(:bowel_movement, severity: 5)
      expect(movement.severity_term).to eq('Pebbles')
    end

    it 'returns nil when severity is nil' do
      movement = build(:bowel_movement, severity: nil)
      expect(movement.severity_term).to be_nil
    end
  end
end
