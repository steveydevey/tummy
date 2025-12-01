class FoodEntriesController < ApplicationController
  def index
    @food_entries = FoodEntry.recent
    @gi_symptoms = GiSymptom.recent
    # Combine and sort by datetime for unified timeline view
    @all_entries = (@food_entries.map { |e| { type: 'food', entry: e, datetime: e.consumed_at } } +
                    @gi_symptoms.map { |s| { type: 'symptom', entry: s, datetime: s.occurred_at } })
                  .sort_by { |e| e[:datetime] }
                  .reverse
  end

  def new
    @food_entry = FoodEntry.new
  end

  def create
    @food_entry = FoodEntry.new(food_entry_params)

    if @food_entry.save
      redirect_to food_entries_path, notice: 'Food entry was successfully created.'
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def food_entry_params
    params.require(:food_entry).permit(:description, :consumed_at, :notes)
  end
end
