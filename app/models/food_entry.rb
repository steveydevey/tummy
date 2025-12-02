class FoodEntry < ApplicationRecord
  include TimestampedEntry

  self.timestamp_column = :consumed_at

  validates :description, presence: true
  validates :consumed_at, presence: true
end
