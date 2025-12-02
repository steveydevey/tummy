class FoodEntriesController < TrackableEntriesController
  def index
    @food_entries = FoodEntry.recent

    # Only show all entries on root path, not on /food_entries
    if request.path == root_path
      # Parse date parameter, default to today (in user's timezone)
      begin
        @selected_date = params[:date].present? ? Date.parse(params[:date]) : Time.zone.today
      rescue ArgumentError
        @selected_date = Time.zone.today
      end

      # Filter entries by selected date
      @food_entries = FoodEntry.on_date(@selected_date).recent
      @bowel_movements = BowelMovement.on_date(@selected_date).recent
      @accidents = Accident.on_date(@selected_date).recent

      # Combine and sort by datetime for unified timeline view
      @all_entries = build_timeline_entries(@food_entries, @bowel_movements, @accidents)
      @show_all_entries = true
    else
      # Show only food entries when accessing /food_entries
      @show_all_entries = false
    end
  end

  def timeline
    # Show all entries without date filtering
    @food_entries = FoodEntry.recent
    @bowel_movements = BowelMovement.recent
    @accidents = Accident.recent

    # Combine and sort by datetime for unified timeline view
    @all_entries = build_timeline_entries(@food_entries, @bowel_movements, @accidents)
  end

  private

  def model_class
    FoodEntry
  end

  def entry_params
    params.require(:food_entry).permit(:description, :consumed_at, :notes)
  end

  def default_path
    food_entries_path
  end

  def entry_variable_name
    'food_entry'
  end

  def timestamp_column
    :consumed_at
  end

  def model_name
    'Food entry'
  end

  def build_timeline_entries(food_entries, bowel_movements, accidents)
    (food_entries.map { |e| { type: 'food', entry: e, datetime: e.consumed_at } } +
     bowel_movements.map { |b| { type: 'bowel_movement', entry: b, datetime: b.occurred_at } } +
     accidents.map { |a| { type: 'accident', entry: a, datetime: a.occurred_at } })
      .sort_by { |e| e[:datetime] }
      .reverse
  end
end
