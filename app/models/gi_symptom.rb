class GiSymptom < ApplicationRecord
  validates :symptom_type, presence: true
  validates :occurred_at, presence: true
  validates :severity, inclusion: { in: 1..10 }, allow_nil: true

  scope :recent, -> { order(occurred_at: :desc) }

  # Common symptom types
  SYMPTOM_TYPES = [
    'Bowel Movement',
    'Nausea',
    'Pain',
    'Bloating',
    'Gas',
    'Diarrhea',
    'Constipation',
    'Cramping',
    'Other'
  ].freeze
end
