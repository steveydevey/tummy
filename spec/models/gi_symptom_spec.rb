require 'rails_helper'

RSpec.describe GiSymptom, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:symptom_type) }
    it { should validate_presence_of(:occurred_at) }
    it { should validate_inclusion_of(:severity).in_array((1..10).to_a).allow_nil }
  end

  describe 'scopes' do
    let!(:symptom1) { create(:gi_symptom, occurred_at: 2.days.ago) }
    let!(:symptom2) { create(:gi_symptom, occurred_at: 1.day.ago) }
    let!(:symptom3) { create(:gi_symptom, occurred_at: Time.current) }

    it 'orders by occurred_at descending' do
      expect(GiSymptom.recent).to eq([symptom3, symptom2, symptom1])
    end
  end
end
