module TimestampedEntry
  extend ActiveSupport::Concern

  included do
    scope :recent, -> { order(timestamp_column => :desc) }
    scope :on_date, ->(date) {
      start_time = Time.zone.parse(date.to_s).beginning_of_day
      end_time = Time.zone.parse(date.to_s).end_of_day
      where(timestamp_column => start_time..end_time)
    }
  end

  class_methods do
    def timestamp_column
      @timestamp_column ||= :occurred_at
    end

    def timestamp_column=(column)
      @timestamp_column = column.to_sym
    end
  end
end

