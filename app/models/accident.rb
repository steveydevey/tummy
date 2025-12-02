class Accident < ApplicationRecord
  validates :occurred_at, presence: true
  validates :accident_type, inclusion: { in: %w[pee poop both] }

  scope :recent, -> { order(occurred_at: :desc) }

  ACCIDENT_TYPES = {
    'pee' => 'Pee',
    'poop' => 'Poop',
    'both' => 'Both'
  }.freeze

  def accident_type_label
    ACCIDENT_TYPES[accident_type] if accident_type
  end
end

