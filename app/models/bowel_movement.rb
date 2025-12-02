class BowelMovement < ApplicationRecord
  validates :occurred_at, presence: true
  validates :severity, inclusion: { in: 1..5 }, allow_nil: true

  scope :recent, -> { order(occurred_at: :desc) }
  scope :on_date, ->(date) { 
    start_time = Time.zone.parse(date.to_s).beginning_of_day
    end_time = Time.zone.parse(date.to_s).end_of_day
    where(occurred_at: start_time..end_time) 
  }

  # Bristol Stool Scale terms
  SEVERITY_TERMS = {
    1 => 'Liquid',
    2 => 'Mush',
    3 => 'Firm',
    4 => 'Logs',
    5 => 'Pebbles'
  }.freeze

  def severity_term
    SEVERITY_TERMS[severity] if severity
  end
end
