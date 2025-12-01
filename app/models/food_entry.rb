class FoodEntry < ApplicationRecord
  validates :description, presence: true
  validates :consumed_at, presence: true

  scope :recent, -> { order(consumed_at: :desc) }
end
