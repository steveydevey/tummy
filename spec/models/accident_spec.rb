require 'rails_helper'

RSpec.describe Accident, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:occurred_at) }
    it { should validate_inclusion_of(:accident_type).in_array(%w[pee poop both]) }
  end

  describe 'scopes' do
    let!(:accident1) { create(:accident, occurred_at: 2.days.ago) }
    let!(:accident2) { create(:accident, occurred_at: 1.day.ago) }
    let!(:accident3) { create(:accident, occurred_at: Time.current) }

    describe '.recent' do
      it 'orders by occurred_at descending' do
        expect(Accident.recent).to eq([accident3, accident2, accident1])
      end
    end

    describe '.on_date' do
      let(:target_date) { 1.day.ago.to_date }
      let!(:accident_on_date) { create(:accident, occurred_at: target_date.beginning_of_day + 12.hours) }
      let!(:accident_before) { create(:accident, occurred_at: target_date.beginning_of_day - 1.hour) }
      let!(:accident_after) { create(:accident, occurred_at: target_date.end_of_day + 1.hour) }

      it 'returns accidents on the specified date' do
        expect(Accident.on_date(target_date)).to include(accident_on_date)
      end

      it 'excludes accidents before the date' do
        expect(Accident.on_date(target_date)).not_to include(accident_before)
      end

      it 'excludes accidents after the date' do
        expect(Accident.on_date(target_date)).not_to include(accident_after)
      end
    end
  end

  describe '#accident_type_label' do
    it 'returns the correct label for pee' do
      accident = build(:accident, accident_type: 'pee')
      expect(accident.accident_type_label).to eq('Pee')
    end

    it 'returns the correct label for poop' do
      accident = build(:accident, accident_type: 'poop')
      expect(accident.accident_type_label).to eq('Poop')
    end

    it 'returns the correct label for both' do
      accident = build(:accident, accident_type: 'both')
      expect(accident.accident_type_label).to eq('Both')
    end

    it 'returns nil when accident_type is nil' do
      accident = build(:accident, accident_type: nil)
      expect(accident.accident_type_label).to be_nil
    end
  end
end

