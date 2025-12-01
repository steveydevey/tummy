class FoodEntriesController < ApplicationController
  def index
    @food_entries = FoodEntry.recent
    @gi_symptoms = GiSymptom.recent
    @bowel_movements = BowelMovement.recent
    # Combine and sort by datetime for unified timeline view
    @all_entries = (@food_entries.map { |e| { type: 'food', entry: e, datetime: e.consumed_at } } +
                    @gi_symptoms.map { |s| { type: 'symptom', entry: s, datetime: s.occurred_at } } +
                    @bowel_movements.map { |b| { type: 'bowel_movement', entry: b, datetime: b.occurred_at } })
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
