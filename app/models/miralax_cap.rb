class MiralaxCap < ApplicationRecord
  include TimestampedEntry

  validates :occurred_at, presence: true
  validates :amount, inclusion: { in: [0.5, 1.0, 1.5, 2.0] }

  AMOUNT_OPTIONS = [0.5, 1.0, 1.5, 2.0].freeze

  def amount_label
    if amount == 1.0
      "1 cap"
    else
      "#{amount} caps"
    end
  end
end

