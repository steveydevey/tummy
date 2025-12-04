require 'rails_helper'

RSpec.describe MiralaxCap, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:occurred_at) }
    it { should validate_inclusion_of(:amount).in_array([0.5, 1.0, 1.5, 2.0]) }
  end

  describe 'scopes' do
    let!(:cap1) { create(:miralax_cap, occurred_at: 2.days.ago) }
    let!(:cap2) { create(:miralax_cap, occurred_at: 1.day.ago) }
    let!(:cap3) { create(:miralax_cap, occurred_at: Time.current) }

    describe '.recent' do
      it 'orders by occurred_at descending' do
        expect(MiralaxCap.recent).to eq([cap3, cap2, cap1])
      end
    end

    describe '.on_date' do
      let(:target_date) { 1.day.ago.to_date }
      let!(:cap_on_date) { create(:miralax_cap, occurred_at: target_date.beginning_of_day + 12.hours) }
      let!(:cap_before) { create(:miralax_cap, occurred_at: target_date.beginning_of_day - 1.hour) }
      let!(:cap_after) { create(:miralax_cap, occurred_at: target_date.end_of_day + 1.hour) }

      it 'returns caps on the specified date' do
        expect(MiralaxCap.on_date(target_date)).to include(cap_on_date)
      end

      it 'excludes caps before the date' do
        expect(MiralaxCap.on_date(target_date)).not_to include(cap_before)
      end

      it 'excludes caps after the date' do
        expect(MiralaxCap.on_date(target_date)).not_to include(cap_after)
      end
    end
  end

  describe '#amount_label' do
    it 'returns "1 cap" for amount 1.0' do
      cap = build(:miralax_cap, amount: 1.0)
      expect(cap.amount_label).to eq('1 cap')
    end

    it 'returns "0.5 caps" for amount 0.5' do
      cap = build(:miralax_cap, amount: 0.5)
      expect(cap.amount_label).to eq('0.5 caps')
    end

    it 'returns "1.5 caps" for amount 1.5' do
      cap = build(:miralax_cap, amount: 1.5)
      expect(cap.amount_label).to eq('1.5 caps')
    end

    it 'returns "2.0 caps" for amount 2.0' do
      cap = build(:miralax_cap, amount: 2.0)
      expect(cap.amount_label).to eq('2.0 caps')
    end
  end
end

