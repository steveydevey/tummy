class BowelMovement < ApplicationRecord
  include TimestampedEntry

  validates :occurred_at, presence: true
  validates :severity, inclusion: { in: 1..5 }, allow_nil: true

  # Bristol Stool Scale terms
  SEVERITY_TERMS = {
    1 => 'Hard Pellets',
    2 => 'Hard Log',
    3 => 'Smooth/soft log (Ideal)',
    4 => 'Soft blobs',
    5 => 'Watery'
  }.freeze

  def severity_term
    SEVERITY_TERMS[severity] if severity
  end
end
