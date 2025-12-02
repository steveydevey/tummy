class Accident < ApplicationRecord
  validates :occurred_at, presence: true
  validates :accident_type, inclusion: { in: %w[pee poop both] }

  scope :recent, -> { order(occurred_at: :desc) }
  scope :on_date, ->(date) { 
    start_time = Time.zone.parse(date.to_s).beginning_of_day
    end_time = Time.zone.parse(date.to_s).end_of_day
    where(occurred_at: start_time..end_time) 
  }

  ACCIDENT_TYPES = {
    'pee' => 'Pee',
    'poop' => 'Poop',
    'both' => 'Both'
  }.freeze

  def accident_type_label
    ACCIDENT_TYPES[accident_type] if accident_type
  end
end

