class AccidentsController < ApplicationController
  def index
    @accidents = Accident.recent
  end

  def new
    @accident = Accident.new
    # Pre-populate date if provided
    if params[:date].present?
      begin
        selected_date = Date.parse(params[:date])
        # Set to noon on the selected date
        @accident.occurred_at = selected_date.beginning_of_day + 12.hours
      rescue ArgumentError
        # Invalid date, ignore
      end
    end
    # Store return_to for redirect after create
    @return_to = sanitize_return_to(params[:return_to] || request.referer) || food_entries_path
  end

  def create
    @accident = Accident.new(accident_params)
    return_to = sanitize_return_to(params[:return_to]) || food_entries_path

    if @accident.save
      redirect_to return_to, notice: 'Accident was successfully created.'
    else
      @return_to = return_to
      render :new, status: :unprocessable_content
    end
  end

  def edit
    @accident = Accident.find(params[:id])
    @return_to = sanitize_return_to(params[:return_to] || request.referer) || accidents_path
  end

  def update
    @accident = Accident.find(params[:id])
    return_to = sanitize_return_to(params[:return_to]) || accidents_path

    if @accident.update(accident_params)
      redirect_to return_to, notice: 'Accident was successfully updated.'
    else
      @return_to = return_to
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @accident = Accident.find(params[:id])
    return_to = sanitize_return_to(params[:return_to]) || accidents_path
    @accident.destroy
    redirect_to return_to, notice: 'Accident was successfully deleted.'
  end

  private

  def accident_params
    params.require(:accident).permit(:occurred_at, :accident_type, :notes)
  end
end

