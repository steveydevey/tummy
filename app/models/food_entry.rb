class FoodEntry < ApplicationRecord
  validates :description, presence: true
  validates :consumed_at, presence: true

  scope :recent, -> { order(consumed_at: :desc) }
  scope :on_date, ->(date) { 
    start_time = Time.zone.parse(date.to_s).beginning_of_day
    end_time = Time.zone.parse(date.to_s).end_of_day
    where(consumed_at: start_time..end_time) 
  }
end
