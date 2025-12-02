class FoodEntriesController < ApplicationController
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
      @all_entries = (@food_entries.map { |e| { type: 'food', entry: e, datetime: e.consumed_at } } +
                      @bowel_movements.map { |b| { type: 'bowel_movement', entry: b, datetime: b.occurred_at } } +
                      @accidents.map { |a| { type: 'accident', entry: a, datetime: a.occurred_at } })
                    .sort_by { |e| e[:datetime] }
                    .reverse
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
    @all_entries = (@food_entries.map { |e| { type: 'food', entry: e, datetime: e.consumed_at } } +
                    @bowel_movements.map { |b| { type: 'bowel_movement', entry: b, datetime: b.occurred_at } } +
                    @accidents.map { |a| { type: 'accident', entry: a, datetime: a.occurred_at } })
                  .sort_by { |e| e[:datetime] }
                  .reverse
  end

  def new
    @food_entry = FoodEntry.new
    # Pre-populate date if provided
    if params[:date].present?
      begin
        selected_date = Date.parse(params[:date])
        # Set to noon on the selected date
        @food_entry.consumed_at = selected_date.beginning_of_day + 12.hours
      rescue ArgumentError
        # Invalid date, ignore
      end
    end
    # Store return_to for redirect after create
    @return_to = sanitize_return_to(params[:return_to] || request.referer) || food_entries_path
  end

  def create
    @food_entry = FoodEntry.new(food_entry_params)
    return_to = sanitize_return_to(params[:return_to]) || food_entries_path

    if @food_entry.save
      redirect_to return_to, notice: 'Food entry was successfully created.'
    else
      @return_to = return_to
      render :new, status: :unprocessable_content
    end
  end

  def edit
    @food_entry = FoodEntry.find(params[:id])
    @return_to = sanitize_return_to(params[:return_to] || request.referer) || food_entries_path
  end

  def update
    @food_entry = FoodEntry.find(params[:id])
    return_to = sanitize_return_to(params[:return_to]) || food_entries_path

    if @food_entry.update(food_entry_params)
      redirect_to return_to, notice: 'Food entry was successfully updated.'
    else
      @return_to = return_to
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @food_entry = FoodEntry.find(params[:id])
    return_to = sanitize_return_to(params[:return_to]) || food_entries_path
    @food_entry.destroy
    redirect_to return_to, notice: 'Food entry was successfully deleted.'
  end

  private

  def food_entry_params
    params.require(:food_entry).permit(:description, :consumed_at, :notes)
  end
end
