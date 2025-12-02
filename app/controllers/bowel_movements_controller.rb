class BowelMovementsController < ApplicationController
  def index
    @bowel_movements = BowelMovement.recent
  end

  def new
    @bowel_movement = BowelMovement.new
    # Pre-populate date if provided
    if params[:date].present?
      begin
        selected_date = Date.parse(params[:date])
        # Set to noon on the selected date
        @bowel_movement.occurred_at = selected_date.beginning_of_day + 12.hours
      rescue ArgumentError
        # Invalid date, ignore
      end
    end
    # Store return_to for redirect after create
    @return_to = sanitize_return_to(params[:return_to] || request.referer) || food_entries_path
  end

  def create
    @bowel_movement = BowelMovement.new(bowel_movement_params)
    return_to = sanitize_return_to(params[:return_to]) || food_entries_path

    if @bowel_movement.save
      redirect_to return_to, notice: 'Bowel movement was successfully created.'
    else
      @return_to = return_to
      render :new, status: :unprocessable_content
    end
  end

  def edit
    @bowel_movement = BowelMovement.find(params[:id])
    @return_to = sanitize_return_to(params[:return_to] || request.referer) || bowel_movements_path
  end

  def update
    @bowel_movement = BowelMovement.find(params[:id])
    return_to = sanitize_return_to(params[:return_to]) || bowel_movements_path

    if @bowel_movement.update(bowel_movement_params)
      redirect_to return_to, notice: 'Bowel movement was successfully updated.'
    else
      @return_to = return_to
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @bowel_movement = BowelMovement.find(params[:id])
    return_to = sanitize_return_to(params[:return_to]) || bowel_movements_path
    @bowel_movement.destroy
    redirect_to return_to, notice: 'Bowel movement was successfully deleted.'
  end

  private

  def bowel_movement_params
    params.require(:bowel_movement).permit(:occurred_at, :severity, :notes)
  end
end
