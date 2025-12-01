class BowelMovement < ApplicationRecord
  validates :occurred_at, presence: true
  validates :severity, inclusion: { in: 1..5 }, allow_nil: true

  scope :recent, -> { order(occurred_at: :desc) }

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
